should = require("chai").should()
request = require("supertest")
libpath = if process.env['LIB_COV'] then '../lib-cov' else '../lib'
ticket = require "#{libpath}/routes/ticket"
app = require "#{libpath}/app"

describe 'post ticket', () ->
  it 'should return error when post without login', (done) ->
    request(app)
      .post("/api/ticket")
      .expect(302, done)

