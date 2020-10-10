{exec} = require 'child_process'

BUILD_CMD = 'coffee --bare --compile --output api.js src/api.coffee'
MINIFY_CMD = 'uglifyjs -c -m --toplevel --mangle-props regex=/^_/ -o api-min.js --keep-classnames --keep-fnames api.js'

task 'build', 'Build api.js', ->
  exec BUILD_CMD,
  (err, stdout, stderr) ->
    console.log stderr if err

task 'minify', 'Minify api.js', ->
  exec MINIFY_CMD,
  (err, stdout, stderr) ->
    console.log stderr if err

task 'publish', 'Build and minify api.js for publishing', ->
  exec BUILD_CMD,
  (err, stdout, stderr) ->
    console.log stderr if err
      exec MINIFY_CMD,
      (err, stdout, stderr) ->
        console.log stderr if err

task 'watch', 'Watch src/ for changes', ->
  exec 'coffee --watch --compile --bare --output api.js src/api.coffee',
  (err, stdout, stderr) ->
    console.log stderr if err

task 'lint', 'Run coffeelint on src/ and test/', ->
  exec 'coffeelint src/ test/',
  (err, stdout, stderr) ->
    console.log stderr if err
    console.log stdout
