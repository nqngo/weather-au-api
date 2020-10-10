# Run `yarn run cake build` to build api.js
# `yarn run coffee test/api.coffee` to run this test

Api = require '../api.js'

main = ->
  api = new Api
  resp = api.search('3053')
  console.log await resp

main()
