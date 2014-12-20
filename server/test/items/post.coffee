setup = require '../setup'
app = require '../../'
config = require '../../config'
db = require '../../db'

User = db.model 'User'
Item = db.model 'Item'

request = require 'supertest'
should = require 'should'

mock = setup.user

describe 'Item POST', ->
  beforeEach db.wipe
  beforeEach (cb) ->
    User.create mock, cb

  it 'should respond with 403 when not logged in', (done) ->
    request(app)
      .post "#{config.apiPrefix}/items"
      .send title: 'no auth', message: 'test'
      .set 'Accept', 'application/json'
      .expect 403, done

  it 'should respond with 200 and information when logged in', (done) ->

    request(app)
      .post "#{config.apiPrefix}/items"
      .send title: 'test', message: 'my note'
      .set 'Accept', 'application/json'
      .query token: mock.token
      .expect 'Content-Type', /json/
      .expect 200
      .end (err, res) ->
        return done err if err?
        should.exist res.body
        res.body.should.be.type 'object'
        res.body.title.should.equal 'test'
        res.body.message.should.equal 'my note'
        done()
