Robot = require("hubot/src/robot")
TextMessage = require("hubot/src/message").TextMessage

path = require 'path'
chai = require 'chai'
nock = require 'nock'
expect = chai.expect

describe 'kenchankunsan', ->
  robot = null
  user = null
  adapter = null
  nockScope = null
  envelope = null

  beforeEach (done) ->
    nock.disableNetConnect()
    nockScope = nock('http://kenchankunsan.herokuapp.com/').get("/.txt")
    envelope = { name: 'mocha', room: '#mocha'}
    robot = new Robot null, 'mock-adapter', yes, 'hubot'

    robot.adapter.on 'connected', ->
      require("../src/kenchankunsan")(robot)
      adapter = robot.adapter
      done()

    robot.run()

  it 'call "hubot kenchankunsan me", replay 200', (done) ->
    nockScope.reply 200, 'けんちゃん…\n'

    adapter.on 'send', (envelope, strings) ->
      expect(strings[0]).to.eq "けんちゃん…"
      done()

    adapter.receive new TextMessage(envelope, "hubot kenchankunsan me")

  it 'call "hubot kenchankunsan me", replay 404', (done) ->
    nockScope.reply 404, ""

    adapter.on 'send', (envelope, strings) ->
      expect(strings[0]).to.eq("")
      done()

    adapter.receive new TextMessage(envelope, "hubot kenchankunsan me")

  it 'call "hubot kenchankunsan", replay 200', (done) ->
    nockScope.reply 200, 'けんちゃん…\n'

    adapter.on 'send', (envelope, strings) ->
      expect(strings[0]).to.eq "けんちゃん…"
      done()

    adapter.receive new TextMessage(envelope, "hubot kenchankunsan")

  afterEach ->
    nockScope = null
    nock.cleanAll()
    robot.server.close()
    robot.shutdown()
