setup = require '../setup'
app = require '../../'
config = require '../../config'
db = require '../../db'

User = db.model 'User'

request = require 'supertest'
should = require 'should'
require 'mocha'

mock = setup.user

describe 'User GET', ->
  beforeEach db.wipe
  beforeEach (cb) ->
    User.create mock, cb

  it 'should respond with 200 and information when logged in', (done) ->
    request(app)
      .get "#{config.apiPrefix}/users/#{mock._id}"
      .set 'Accept', 'application/json'
      .query token: mock.token
      .expect 'Content-Type', /json/
      .expect 200
      .end (err, res) ->
        return done err if err?
        should.exist res.body
        res.body.should.be.type 'object'
        res.body._id.should.equal mock._id
        done()


  it 'should respond with 403 when not logged in', (done) ->
    request(app)
      .get "#{config.apiPrefix}/users/#{mock._id}"
      .set 'Accept', 'application/json'
      .expect 403
      .end (err, res) ->
        return done err if err?
        should(Object.keys(res.body).length).equal 0
        done()
  it 'should respond with 200 and information when logged in with username query', (done) ->
    request(app)
      .get "#{config.apiPrefix}/users/#{mock.username}"
      .set 'Accept', 'application/json'
      .expect 'Content-Type', /json/
      .query token: mock.token
      .expect 200
      .end (err, res) ->
        return done err if err?
        should.exist res.body
        res.body.should.be.type 'object'
        res.body._id.should.equal mock._id
        done()

  it 'should respond with 403 and when not logged in with username query', (done) ->
    request(app)
      .get "#{config.apiPrefix}/users/#{mock.username}"
      .set 'Accept', 'application/json'
      .expect 403
      .end (err, res) ->
        return done err if err?
        should(Object.keys(res.body).length).equal 0
        done()
