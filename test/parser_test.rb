gem 'simple-hash'

require 'test/unit'
require 'open3'
require 'shellwords'

class SimpleHash
  def initialize(hash)
    @hash = hash
  end

  def method_missing(method_name, *args)
    @hash.fetch(method_name)
  end
end

PARSER_PATH = File.join(File.dirname(__FILE__), '../parser')

class Parser
  def self.parse(input)
    out, err, status = Open3.capture3(PARSER_PATH, stdin_data: input)

    SimpleHash.new(
      out: out,
      err: err,
      success?: status.success?,
      output: out + err
    )
  end
end

class ParserTest < Test::Unit::TestCase
  def self.test(&block)
    define_method("test_#{rand(10e10).to_s(16)}", &block)
  end

  def assert_parse(input)
    result = Parser.parse(input)

    assert_equal(
      "",
      result.err,
      "#{result.output}\n\n  ./parser #{input.shellescape}\n\n"
    )
  end

  test { assert_parse("regular text") }
  test { assert_parse("{{ variable }} ") }
  test { assert_parse("{{ variable | filter }} ") }
  test { assert_parse("{{ variable | filter arg: value, arg2: [V1, 1] }}") }
  test { assert_parse("{{ variable | filter1 | filter2 }} ") }
end

__END__

'regular text'
  'so how do you do this? with {}? or %?'
  '{{ user.names | join ", " }}',
  """
    {% if user.admin %}
      {{ "delete everything" | link_to "/secret/button" }}
    {% endif %}
  """,
  """
    {% for user in users %}
      {{ user.name }}
    {% endfor %}
  """
