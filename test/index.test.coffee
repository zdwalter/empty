should = require("chai").should()
request = require("supertest")
libpath = if process.env['LIB_COV'] then '../lib-cov' else '../lib'
app = require "#{libpath}/app"

describe 'index', () ->
  it 'should return no error', (done) ->
    request(app)
      .get("/")
      .expect(200, done)

