setup = require '../setup'
app = require '../../'
config = require '../../config'
db = require '../../db'

User = db.model 'User'
Item = db.model 'Item'

request = require 'supertest'
should = require 'should'

mock = setup.user
mockPlug = setup.item

describe 'Item PATCH', ->
  beforeEach db.wipe
  beforeEach (cb) ->
    User.create mock, (err, user) ->
      cb err, user if err?
      Item.create mockPlug, cb

  it 'should respond with 403 when not logged in', (done) ->
    request(app)
      .patch "#{config.apiPrefix}/items/123"
      .set 'Accept', 'application/json'
      .expect 403, done

  it 'should respond with 200 and information when logged in', (done) ->
    mod =
      title: 'newplug'

    request(app)
      .patch "#{config.apiPrefix}/items/#{mockPlug._id}"
      .set 'Accept', 'application/json'
      .query token: mock.token
      .send mod
      .expect 'Content-Type', /json/
      .expect 200
      .end (err, res) ->
        return done err if err?
        should.exist res.body
        res.body.should.be.type 'object'
        res.body._id.should.equal mockPlug._id
        res.body.title.should.equal 'newplug'
        done()
