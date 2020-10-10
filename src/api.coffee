get = require('bent') 'json'

API_BASE = 'https://api.weather.bom.gov.au/v1'
API_FORECAST_DAILY = 'forecasts/daily'
API_FORECAST_3HOURLY = 'forecasts/3-hourly'
API_OBSERVATIONS = 'observations'
API_SEARCH = 'locations?search='

class Api

  constructor: (@_geohash) ->
    ###
    Initialise the API object, use a geohash if provided.
    ###
    @response_timestamp = null

  response_timestamp: ->
    @_response_timestamp

  search: (search) ->
    ###
    Return search result list or [] if no matches
    Example:
    https://api.weather.bom.gov.au/v1/locations?search=3130
    https://api.weather.bom.gov.au/v1/locations?search=Parkville+VIC
    ###
    unless search?.length
      return []
    # The search API doesn't like the dash character.
    search = search.replace('-', '+')

    resp = await get "#{API_BASE}/#{API_SEARCH}#{search}"
    @_response_timestamp = await resp.metadata.response_timestamp
    @_geohash = await resp.data[0].geohash
    # Return a promise
    resp.data

  forecasts_daily: ->
    ###
    Return the daily forecasts
    ###

  location: ->

module.exports = Api
