# Run `yarn run cake build` to build api.js
# `yarn run cake test` to run this test
chai = require 'chai'
expect = chai.expect
should = chai.should()

Api = require '../api.js'

describe 'Api', ->
  it 'returns Carlton, VIC when searching postcode 3053', ->
    api = new Api
    resp = await api.search '3053'
    resp.length.should.equal 1
    expect(resp[0].name).to.equal 'Carlton'
    expect(resp[0].state).to.equal 'VIC'
