
##
# * GET ticket
##

mongodb = require("../mongodbClient")

exports.post = (req, res) ->
  ticket = req.body
  mongodb.insert "ticket", ticket, (err, result) ->
    if err
      return res.send error: 1
    return res.send result
