# Run `yarn run cake build` to build api.js
# `yarn run cake test` to run this test
chai = require 'chai'
chai.use require 'chai-datetime'
expect = chai.expect

Api = require '../api.js'
api = new Api

now = Date.now()

describe 'Api', ->

  it 'returns Carlton, VIC when searching postcode 3053', ->
    result = await api.search '3053'
    expect(result).to.have.lengthOf 1
    expect(result[0].name).to.equal 'Carlton'
    expect(result[0].state).to.equal 'VIC'

  it 'returns postcode 3053 when searching Carlton+VIC', ->
    result = await api.search 'Carlton+VIC'
    # Because Carlton returns multiple results
    # filter to find if a result contain the Carlton
    # we want
    carlton = result.filter (r) ->
      r.name is 'Carlton' and r.state is 'VIC' and r.postcode is '3053'
    expect(carlton).to.have.lengthOf 1

  it 'shows Carlton daily forecasts for the next 7 days', ->
    result = await api.forecasts_daily()
    expect(result).to.have.lengthOf.at.least 7
    # Set today to midnight
    today = new Date()
    today.setHours 0,0,0,0
    # Test if it contains today result
    expect(new Date result[0].date).to.equalDate(today)
    # Test membership for each result
    for day in result
      expect(day).to.include.all.keys 'rain', 'uv', 'astronomical', 'temp_max',
      'temp_min', 'extended_text'

  it 'gets weather warnings for Carlton if there is any', ->
    current_timestamp = new Date()
    result = await api.warnings()
    # Only check if we fetch the response from server
    # There might not be any warning
    expect(new Date api.response_timestamp()).to.be.afterTime current_timestamp

  it 'get the warning with ID VIC_RC022_IDV36310', ->
    result = await api.warning 'VIC_RC022_IDV36310'
    expect(result.id).to.equal 'VIC_RC022_IDV36310'
    expect(result.title).to.equal 'Flood Warning for Yarra River'
    expect(result.type).to.equal 'flood_warning'
