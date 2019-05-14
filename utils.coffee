_ = require('underscore')
color = require('kleur')

json = (obj) ->
  JSON.stringify(obj, null, 2)

isColored = (argv) ->
  typeof argv.colored != "boolean" || argv.colored == true

log = (string, argv = {}) ->
  string = JSON.stringify(string) unless typeof string == "string"
  console.error(string)

error = (string, argv = {}) ->
  string = JSON.stringify(string) unless typeof string == "string"

  if isColored(argv)
    console.error(color.red(string))
  else
    console.error(string)

module.exports = { log, json, error }
