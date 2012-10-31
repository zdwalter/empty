
##
# * GET request
##

mongodb = require("../mongodbClient")

exports.post = (req, res) ->
  request = req.body
  mongodb.insert "request", request, (err, result) ->
    if err
      return res.send error: 1
    return res.send result
