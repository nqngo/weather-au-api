# weather-au-api

![GitHub Workflow Status (branch)](https://img.shields.io/github/workflow/status/nqngo/weather-au-api/CI%20test/main?label=ci)
[![GitHub package.json version](https://img.shields.io/github/package-json/v/nqngo/weather-au-api)](https://github.com/nqngo/weather-au-api)
[![GitHub license](https://img.shields.io/github/license/nqngo/weather-au-api)](https://github.com/nqngo/weather-au-api/blob/main/LICENSE)

NodeJS API library for accessing api.weather.bom.gov.au

This API is inspired by [tonyallan/weather-au](https://github.com/tonyallan/weather-au).

As the API is reversed engineered from the usage in https://weather.bom.gov.au with no information about future access arrangements or availability, use this module as your own risks.

## Installation

Through `npm`:

```bash
npm install weather-au-api
```

Through `yarn`:

```bash
yarn add weather-au-api
```

## Example Usage

```javascript
var Api = require('weather-au-api');
var api = new Api();

main = async function() {
  # Set your current location
  await api.search('3053');
  # Retrieve the daily forecasts for the next 7 days
  let resp = await api.forecasts_daily();
  console.log(resp);
};

main();
```

## Usage

### Set the geohash (optional)
#### api = new Api(geohash)

When initialising a new `Api` object, a `geohash` can be optionally provided.
This will bypass the need to use the `search()` function to set location.

```javascript
# Set the location to Carlton, VIC
api = new Api('r1r0fyd');
```

------------------------------------
### Set the search location
#### api.search(string)

Search by post code or location string and set the `geohash` location to first location returned through the API.
When searching using location string, join the terms with `+`.
Return a JSON list of locations found.

```javascript
carlton = await api.search('3053');
console.log(carlton.data);
carlton2 = await api.search('Carlton+VIC');
console.log(carlton2);
```

------------------------------------
### Get the 3-hourly forecasts
#### api.forecasts_3hourly()

Get bom.gov.au 3hourly forecasts for today.
A `geohash` must be set when initialising or through running `api.search()`.
Return a JSON list of forecasts.

```javascript
forecasts = await api.forecasts_3hourly();
console.log(forecasts);
```

------------------------------------
### Get the daily forecasts
#### api.forecasts_daily()

Get bom.gov.au daily forecasts for the next 7-8 days.
A `geohash` must be set when initialising or through running `api.search()`.
Return a JSON list of daily forecasts.

```javascript
forecasts = await api.forecasts_daily();
console.log(forecasts);
```

------------------------------------
### Get warnings
#### api.warnings()

Get bom.gov.au current warnings. Might be empty if there is no warnings for current location.
A `geohash` must be previously set.
Return a JSON list of warnings.

```javascript
warnings = await api.warnings();
console.log(warnings);
```

------------------------------------
### Get specific warning
#### api.warning(warning_id)

Get the warning with `warning_id`. Get `warning_id` from `api.warnings()`.
Return a JSON object.

```javascript
warning = await api.warning('VIC_RC022_IDV36310');
console.log(warning);
```

------------------------------------
### Get observations reading
#### api.observations()

Get the observations reading for the current location.
Return a JSON object.

```javascript
observations = await api.observations();
console.log(observations);
```

------------------------------------
### Get last response timestamp
#### api.response_timestamp()

Get the last response timestamp.

```javascript
timestamp = api.response_timestamp();
```
