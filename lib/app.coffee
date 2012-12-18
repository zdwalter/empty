###
Module dependencies.
###
express = require("express")
path = require("path")

## private modules
routes = require("./routes")
example = require("./routes/example")

config = require("./config")
logger = require("./logger")

app = express()
app.configure ->
  app.set "port", process.env.PORT or config.web.port
  app.set "portSSL", process.env.PORT_SSL or config.web.portSSL
  app.set "views", __dirname + "/../views"
  app.set "view engine", "jade"
  app.use express.favicon()
  app.use express.logger("dev")
  app.use express.bodyParser()
  app.use express.cookieParser('need a secret')
  app.use express.session()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(path.join(__dirname, "/../public"))

app.configure "development", ->
  #app.use express.errorHandler()

app.configure "test", ->
  #app.use express.errorHandler()
  error = (err, req, res, next) ->
    logger.error err.stack
  app.use error
# middlewares

basicAuth = express.basicAuth(
  (username, password) ->
    return username is 'admin' and password is 'admin111111'
  , 'restrict area')
#TODO: put {method, path, middlewares, function} to separate config files
app.get "/", basicAuth, routes.index
app.get "/api/examples", basicAuth, example.list
app.get "/migrate", basicAuth, routes.migrate


# start server
if (!module.parent)
  http = require("http")
  http.createServer(app).listen app.get("port"), ->
    logger.info "Express server listening on port " + app.get("port")
else
  module.exports = app

