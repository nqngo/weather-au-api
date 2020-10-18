# Run `yarn run cake build` to build api.js
# `yarn run cake test` to run this test
chai = require 'chai'
chai.use require 'chai-datetime'
expect = chai.expect

Api = require '../api.js'
api = new Api

now = Date.now()

describe 'Api', ->

  it 'returns nothing when search for invalid string', ->
    result = await api.search 'a'
    expect(result).to.be.empty
    result = await api.search 'aaaaaaaaaaaaaaaaa'
    expect(result).to.be.empty

  it 'returns Carlton, VIC when search for postcode 3053', ->
    result = await api.search '3053'
    expect(result).to.have.lengthOf 1
    expect(result[0].name).to.equal 'Carlton'
    expect(result[0].state).to.equal 'VIC'

  it 'returns postcode 3053 when search for Carlton+VIC', ->
    result = await api.search 'Carlton+VIC'
    # Because Carlton returns multiple results
    # filter to find if a result contain the Carlton
    carlton = result.filter (r) ->
      r.name is 'Carlton' and r.state is 'VIC' and r.postcode is '3053'
    expect(carlton).to.have.lengthOf 1

  it 'shows Carlton daily forecasts for the next 7 days', ->
    result = await api.forecasts_daily()
    expect(result).to.have.lengthOf.at.least 7
    # Set today to midnight
    today = new Date()
    today.setHours 0,0,0,0
    # Test membership for each result
    for day in result
      expect(day).to.include.all.keys 'rain', 'uv', 'astronomical', 'temp_max',
      'temp_min', 'extended_text'

  it 'gets weather warnings for Carlton if there is any', ->
    result = await api.warnings()
    expect(api.response_timestamp()).to.be.not.empty

  it 'get the warning with ID VIC_RC022_IDV36310', ->
    result = await api.warning 'VIC_RC022_IDV36310'
    expect(result.id).to.equal 'VIC_RC022_IDV36310'
    expect(result.title).to.equal 'Flood Warning for Yarra River'
    expect(result.type).to.equal 'flood_warning'

  it 'get the nearest observation reading from Carlton', ->
    result = await api.observations()
    expect(result.station.name).to.equal 'Melbourne (Olympic Park)'
    expect(result.station.bom_id).to.equal '086338'
