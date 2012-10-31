mongodb = require("mongodb")
poolMoudle = require("generic-pool")
config = require("./config").mongodb
logLevel = require("./config").log.level
dbname = config.db

mongoClient = {}

connectionPool = poolMoudle.Pool(
  name: "mongodb"
  create:(callback) ->
    _client = new mongodb.Db(dbname, new mongodb.Server(config.host, config.port, {auto_reconnect:true}), {safe: true})
    return callback null, _client
  destroy:(client) ->
      client.close()
  max:10
  idleTimeoutMillis:3000
  log: logLevel is "debug" #or process.env.NODE_ENV is "test"
)

mongoClient.destroyAllNow = () ->
  connectionPool.drain () ->
    connectionPool.destroyAllNow()

releaseClient = (client) ->
  connectionPool.release client if client?

getClient = (callback) ->
  connectionPool.acquire (err, client) ->
    if err
      return callback err
    return callback null, client

getCollection = (collectionName, callback) ->
  getClient (err, client) ->
    if err
      return callback err
    return client.collection collectionName, (err, collection) ->
      if err
        releaseClient client
        return callback err
      return callback err, client, collection

mongoClient.insert = (collectionName, docs, callback) ->
  getCollection collectionName, (err, client, collection) ->
    if err
      return callback err
    collection.insert docs, {safe: true}, (err, objs) ->
      releaseClient client
      if err
        return callback err
      return callback err, objs


module.exports = mongoClient
