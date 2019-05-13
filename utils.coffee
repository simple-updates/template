log = console.log
_ = require('underscore')
color = require('kleur')

json = (obj) ->
  JSON.stringify(obj, null, 2)

error = (string, argv = {}) ->
  if typeof argv.colored != "boolean"
    argv.colored = true

  if argv.colored and typeof string == "string"
    console.error(color.red(string))
  else
    console.error(string)

matchesNode = (node, state, argv = {}) ->
  if argv.grep
    node.path.match(argv.grep)
  else
    if state == "fail"
      if node.type  == "rule.fail"
        true
      else
        false
    else
      if node.type == "rule.match"
        true
      else
        false

printError = (source, exception, tracer, argv = {}) =>
  throw exception unless exception.location
  log(tracer.getParseTreeString()) if argv.debug
  log(source)

  start = exception.location.start
  end = exception.location.end

  error('^'.padStart(start.column, ' ').padEnd(end.column, '^')) if start
  error("#{exception.name}: at \"#{exception.found || ""}\" (#{exception.message})")

module.exports = { log, json, error, printError, matchesNode }
