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
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(path.join(__dirname, "/../public"))

app.configure "development", ->
  app.use express.errorHandler()

#TODO: put {method, path, middlewares, function} to separate config files
app.get "/", routes.index
app.get "/api/examples", example.list
app.post "/api/ticket", ticket.post


# start server
http.createServer(app).listen app.get("port"), ->
  logger.info "Express server listening on port " + app.get("port")

