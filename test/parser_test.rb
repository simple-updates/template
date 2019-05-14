require 'bundler'
Bundler.require(:default)

require 'open3'
require 'shellwords'

$irb_done = false

def irb
  binding.of_caller(1).irb unless $irb_done
  $irb_done = true
end

PARSER_PATH = File.join(File.dirname(__FILE__), '../parser')
EXAMPLES = Dir[File.join(File.dirname(__FILE__), '../examples/*')]
README = File.join(File.dirname(__FILE__), '../README')

class Parser
  def self.parse(input)
    out, err, status = Open3.capture3(
      "#{PARSER_PATH} --debug=true --colored=false",
      stdin_data: input
    )

    ::Simple::Hash.new(
      out: out,
      err: err,
      success?: status.success?,
      output: out + err
    )
  end
end

class ParserTest < Test::Unit::TestCase
  def self.test(name = nil, &block)
    define_method("test_#{name || block.source}", &block)
  end

  def assert_parse(input)
    result = Parser.parse(input)

    assert_equal(
      "",
      result.err,
      "#{result.output}\n\n  ./parser \"#{input.gsub('"') { "\\\"" }}\"\n\n"
    )
  end

  test { assert_parse("regular text") }
  test { assert_parse("{{ variable }} ") }
  test { assert_parse("{{ variable | filter }} ") }
  test { assert_parse("{{ variable | filter arg: value, arg2: [V1, 1] }}") }
  test { assert_parse("{{ variable | filter1 | filter2 }} ") }
  test { assert_parse("so how do you do this? with {}? or %?") }
  test { assert_parse("{{ user.names | join \", \" }}") }

  (EXAMPLES + [README]).each do |example|
    test(example) { assert_parse(example) }
  end
end
