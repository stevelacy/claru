setup = require '../setup'
app = require '../../'
config = require '../../config'
db = require '../../db'

User = db.model 'User'

request = require 'supertest'
should = require 'should'
require 'mocha'

mock = setup.user

describe 'User GET plural', ->
  beforeEach db.wipe
  beforeEach (cb) ->
    User.create mock, cb

  it 'should respond with 403 when not logged in', (done) ->
    request(app)
      .get "#{config.apiPrefix}/users"
      .set 'Accept', 'application/json'
      .expect 403, done

  it 'should respond with 200 and information when logged in', (done) ->
    request(app)
      .get "#{config.apiPrefix}/users"
      .set 'Accept', 'application/json'
      .query token: mock.token
      .expect 'Content-Type', /json/
      .expect 200
      .end (err, res) ->
        return done err if err?
        should.exist res.body
        Array.isArray(res.body).should.equal true
        res.body.length.should.equal 1
        res.body[0]._id.should.equal mock._id
        should.not.exist res.body[0].token, 'should not show user token'
        done()
