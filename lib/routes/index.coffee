
#
# * GET home page.
# 
exec = require('child_process').exec

exports.index = (req, res) ->
  res.render "index",
    title: "Express"

exports.migrate = (req, res) ->
  username = req.query.username
  exec "cd #{__dirname}/../../../; ./migrate.sh config.production #{username}", (error, stdout, stderr) ->
    console.log error
    console.log stdout
    console.log stderr
    res.send "error: #{error}\nstdout: #{stdout}\nstderr: #{stderr}", {'Content-Type': 'text/plain'}, 200
