var peg = require("pegjs")
var fs = require('fs')
var process = require('process')

var filename = "template.pegjs"

var grammar = fs.readFileSync(process.cwd() + "/" + filename).toString()

var ast = peg.parser.parse(grammar)

var parser = peg.generate(grammar);

console.log(parser.parse(process.argv[2] || "this is an {{ example }}"))
