peg = require('pegjs')
fs = require('fs')
process = require('process')
_ = require('underscore')
chalk = require('chalk')
Tracer = require('pegjs-backtrace')

log = console.log
json = (obj) -> JSON.stringify(obj, null, 2)
error = (string) -> log(chalk.redBright(string))

printError = (source, exception) ->
  throw exception unless exception.location
  log(tracer.getBacktraceString())
  log(source)

  start = exception.location.start
  end = exception.location.end

  error('^'.padStart(start.column, ' ').padEnd(end.column, '^')) if start
  error("#{exception.name}: at \"#{exception.found || ""}\" (#{exception.message})")

source = fs.readFileSync(0).toString().trim()
grammar = fs.readFileSync('template.pegjs', 'utf8')
parser = peg.generate(grammar, trace: true)
tracer = new Tracer(source, showFullPath: true)

try
  log(json(parser.parse(source, tracer: tracer)))
catch exception
  printError(source, exception)
  process.exit(1)
