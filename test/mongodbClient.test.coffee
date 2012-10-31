should = require('chai').should()
libpath = if process.env['LIB_COV'] then '../lib-cov' else '../lib'
mongoClient = require "#{libpath}/mongodbClient"

describe 'getClient', () ->
  it 'should return no error when insert', (done) ->
    return mongoClient.insert 'some_collection', {data: 'test'}, (err, objs) ->
      should.not.exist err
      objs.should.exist
      return done()

