setup = require '../setup'
app = require '../../'
config = require '../../config'
db = require '../../db'

User = db.model 'User'

request = require 'supertest'
should = require 'should'
require 'mocha'

mock = setup.user

describe 'User PATCH', ->
  beforeEach db.wipe
  beforeEach (cb) ->
    User.create mock, cb

  it 'should respond with 403 when not logged in', (done) ->
    request(app)
      .patch "#{config.apiPrefix}/users/123"
      .set 'Accept', 'application/json'
      .expect 403, done

  it 'should respond with 200 and information when logged in', (done) ->
    mod =
      name: 'Mike'

    request(app)
      .patch "#{config.apiPrefix}/users/#{mock._id}"
      .set 'Accept', 'application/json'
      .query token: mock.token
      .send mod
      .expect 'Content-Type', /json/
      .expect 200
      .end (err, res) ->
        return done err if err?
        should.exist res.body
        res.body.should.be.type 'object'
        res.body._id.should.equal mock._id
        res.body.name.should.equal 'Mike'
        done()
