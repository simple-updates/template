let log = console.log
let peg = require("pegjs")
let fs = require('fs')
let process = require('process')
var Tracer = require('pegjs-backtrace');

let filename = "template.pegjs"

let grammar = fs.readFileSync("template.pegjs", "utf8")
let parser = peg.generate(grammar, { trace: true })
let source = process.argv[2] || "this is an {{ example }}"
let tracer = new Tracer(source, { showFullPath: true })

try {
  let result = parser.parse(source, { tracer: tracer })
  log(result)
} catch (error) {
  log(tracer.getBacktraceString())
  log({ source: source })
  log({ name: error.name })
  log({ message: error.message })
  log({ expected: error.expected })
  log({ found: error.found })
  log({ found: error.location })
}

