
##
# * GET ticket
##

mongodb = require("../mongodbClient")
logger = require("../logger")

exports.post = (req, res) ->
  ticket = req.body
  mongodb.insert "ticket", ticket, (err, result) ->
    if err
      logger.error err
      return res.send error: 1
    return res.send result
