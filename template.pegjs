{
  function j(string) { return string.join('') }
  function r() {
    let result = {}

    for (let i = 0; i < (arguments.length / 2); i += 1) {
      if (arguments[i * 2 + 1] !== null) {
        result[arguments[i * 2]] = arguments[i * 2 + 1]
      }
    }

    return result
  }
}

template = (interpolation / tag / text)+

text =
  $(!open_interpolation !open_tag .)+

space = (" " / "\n")+
ws "whitespace" = (" " / "\n")*

// {{ this }}
open_interpolation = "{{"
close_interpolation = "}}"

interpolation =
  open_interpolation space
  value:value space
  filters:filter*
  ws close_interpolation {
    return r('interpolation', r('filters', filters, 'value', value))
  }

filter =
    "|" ws
    method:method ws
    parameters:parameters?
    { return r('method', method, 'parameters', parameters) }

parameters = short_array / short_hash / value

// {% this %}
open_tag = "{%"
close_tag = "%}"

not_close_tag =
  ws !close_tag value:value ws { return value }

tag =
  (
    if_value:(if_tag template)
    elsif_values:(elsif_tag template)*
    else_value:(else_tag template)?
    endif_tag
  ) { return r('if', if_value, 'elsif', elsif_value, 'else', else_value) }
  /
  (
    for_value:(for_tag template)
    endfor_tag
  ) { return r('for', for_value) }

if_tag = open_tag ws "if" expression ws close_tag
elsif_tag = open_tag ws "elsif" expression ws close_tag
else_tag = open_tag ws "else" ws close_tag
endif_tag = open_tag ws "endif" ws close_tag

for_tag = open_tag ws "for" ws variable ws "in" ws expression ws close_tag
endfor_tag = open_tag ws "endfor" ws close_tag

// value
value =
  value:(
    v:integer { return r('integer', v) } /
    v:float { return r('float', v) } /
    v:string { return r('string', v) } /
    v:array { return r('array', v) } /
    v:hash { return r('hash', v) } /
    v:boolean { return r('boolean', v) } /
    v:variable { return r('variable', v) }
  )

reserved_names =
  "if" / "elsif" / "else" / "endif" /
  "for" / "endfor" /
  "unless" / "endunless" /
  "case" / "when" / "endcase" /
  "assign" / "endassign" /
  "comment" / "endcomment" /
  "contains"

alpha = [a-zA-Z]
alpha_num = [a-zA-Z0-9]
digit = [0-9]
non_zero_digit = [1-9]
name = $(alpha (alpha_num / ("_" alpha_num))*)
variable = $(name ("." name)*)
method = name
integer = $(non_zero_digit (digit / "_")*)
float = "-"? integer "." integer ("e" ("+" / "-") integer)
string_delimiter = '"' / "'"
string = $(string_delimiter (!string_delimiter .)* string_delimiter)
array = "[" ws (value ws "," ws)* "]"
short_array = (value ws "," ws)+
key = name / string
boolean = "true" / "false"

key_value = key:key ":" space value:value ws { return { key, value } }

// {}
// { a: 1 }
// { a: 1, b: 2 }
hash =
  "{"
    ws
    key_values:(
      key_value
      (
        ws "," ws key_value:key_value
        { return key_value }
      )*
    )?
    ws
  "}"
  { return key_values }

// a: 1
// a: 1, b: 2
short_hash =
  key_value
  (
    ws "," ws key_value:key_value
    { return key_value }
  )*

expression = value
