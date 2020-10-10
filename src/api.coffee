get = require('bent') 'json'
htmlToText = require 'html-to-text'

API_BASE = 'https://api.weather.bom.gov.au/v1'
API_FORECAST_DAILY = 'forecasts/daily'
API_FORECAST_3HOURLY = 'forecasts/3-hourly'
API_OBSERVATIONS = 'observations'
API_WARNINGS = 'warnings'
API_LOCATION = 'locations'
API_SEARCH = 'locations?search='

class Api

  constructor: (@_geohash) ->
    ###
    Initialise the API object, use a geohash if provided.
    ###
    @_location = "#{API_LOCATION}/#{@_geohash}"
    @_response_timestamp = null

  response_timestamp: ->
    @_response_timestamp

  search: (search) ->
    ###
    Return search result list or [] if no matches
    and set the api geohash to first result in the list.
    Example:
    https://api.weather.bom.gov.au/v1/locations?search=3053
    https://api.weather.bom.gov.au/v1/locations?search=Carlton+VIC
    ###
    unless search?.length
      return []
    # The search API doesn't like the dash character.
    search = search.replace('-', '+')

    resp = await get "#{API_BASE}/#{API_SEARCH}#{search}"
    @_response_timestamp = await resp.metadata.response_timestamp
    @_geohash = await resp.data[0].geohash
    @_location = await "#{API_LOCATION}/#{@_geohash}"

    return resp.data

  forecasts_daily: ->
    ###
    Return the daily forecasts for today and the next 7 days;
    Return an empty array if not found
    Example:
    https://api.weather.bom.gov.au/v1/locations/r1r0fyd/forecasts/daily
    ###
    unless @_geohash
      return []
    resp = await get "#{API_BASE}/#{@_location}/#{API_FORECAST_DAILY}"
    @_response_timestamp = await resp.metadata.response_timestamp

    return resp.data

  warnings: ->
    ###
    Return all warnings for this location;
    Return an empty array if nothing is found
    Example:
    https://api.weather.bom.gov.au/v1/locations/r1r0fyd/warnings
    ###
    unless @_geohash
      return []
    resp = await get "#{API_BASE}/#{@_location}/#{API_WARNINGS}"
    @_response_timestamp = await resp.metadata.response_timestamp

    return resp.data

  warning: (id, wordwrap) ->
    ###
    Return the given detailed warning;
    Set `wordwrap` to an integer to wrap long paragraphs.
    Return an empty object if nothing is found
    Example:
    https://api.weather.bom.gov.au/v1/warnings/VIC_RC022_IDV36310
    ###
    unless id?.length
      return {}
    resp = await get "#{API_BASE}/#{API_WARNINGS}/#{id}"
    @_response_timestamp = await resp.metadata.response_timestamp

    output = resp.data
    # HtmlToText config
    config =
      wordwrap: wordwrap
      singleNewLineParagraphs: true

    output.message = htmlToText.fromString resp.data.message, config
    return output

module.exports = Api
