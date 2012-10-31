###
Module dependencies.
###
express = require("express")
http = require("http")
path = require("path")

## private modules
routes = require("./routes")
example = require("./routes/example")
ticket = require("./routes/ticket")

config = require("./config")
logger = require("./logger")

app = express()
app.configure ->
  app.set "port", process.env.PORT or config.web.port
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


restrict = (req, res, next) ->
  if req.session?.user
    return next()
  else
    if req.xhr
      res.send {error: 1, error_msg: "Access denied!"}
    else
      req.session.error = "Access denied!"
      res.redirect "/login"

#TODO: put {method, path, middlewares, function} to separate config files
app.get "/", routes.index
app.get "/api/examples", example.list
app.post "/api/ticket", [restrict], ticket.post


# start server
if (!module.parent)
  http.createServer(app).listen app.get("port"), ->
    logger.info "Express server listening on port " + app.get("port")
else
  module.exports = app

