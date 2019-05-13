template = (interpolation / tag / text)+

space = (" " / "\n")+
ws "whitespace" = (" " / "\n")*
single_quote = "'"
double_quote = '"'
open_interpolation = "{{"
close_interpolation = "}}"
open_tag = "{%"
close_tag = "%}"
nil = "null"
true = "true"
false = "false"

alpha = [a-zA-Z]+
alpha_num = [a-zA-Z0-9]+
digit = [0-9]+
non_zero_digit = [1-9]+

interpolation =
  open_interpolation space
  value:value space
  filters:filter*
  ws close_interpolation {
    return { 'interpolation': { filters, value } }
  }

tag = assign / if_ / for_

text =
  text:$(!open_interpolation !open_tag .)+
  { return { text } }

expression =
  value:value space filters:filter*
  { return { value, filters } }

filter =
  "|" ws
  method:method ws
  parameters:parameters
  { return { method, parameters } }

parameters =
  value:(short_hash / short_array / value)

not_close_tag =
  ws !close_tag value:value ws
  { return value }

assign =
  variable:variable ws "=" ws value:value
  { return { variable, value } }

if_ =
  if_value:(if_tag template)
  elsif_values:(elsif_tag template)*
  else_value:(else_tag template)?
  endif_tag
  { return { 'if': if_value, 'elsif': elsif_values, 'else': else_value } }

for_ =
  for_value:(for_tag template)
  endfor_tag
  { return { 'for': for_value } }

if_tag = open_tag ws "if" ws expression ws close_tag
elsif_tag = open_tag ws "elsif" ws expression ws close_tag
else_tag = open_tag ws "else" ws close_tag
endif_tag = open_tag ws "endif" ws close_tag

for_tag = open_tag ws "for" ws variable ws "in" ws expression ws close_tag
endfor_tag = open_tag ws "endfor" ws close_tag

value =
  value:(
    nil:nil
    { return { nil } } /
    integer:integer
    { return { integer } } /
    float:float
    { return { float } } /
    string:string
    { return { string } } /
    array:array
    { return { array } } /
    hash:hash
    { return { hash } } /
    boolean:boolean
    { return { boolean } } /
    variable:variable
    { return { variable } }
  )

name = $(alpha (alpha_num / ("_" alpha_num))*)
variable = $(name ("." name)*)
method = name
integer = $(non_zero_digit (digit / "_")*)
float = "-"? integer "." integer ("e" ("+" / "-") integer)
single_quoted_string = single_quote value(!single_quote .)* single_quote
double_quoted_string = double_quote (!double_quote .)* double_quote
string = $(single_quoted_string / double_quoted_string)
key = name / string
boolean = true / false

key_value =
  key:key ":" space value:value ws
  { return { key, value } }

array =
  "[" ws
  values:(
    first_value:value
    other_values:(ws "," ws value:value ws { return value })*
    { return [first_value, ...other_values] }
  )?
  ws "]"
  { return values }

short_array =
  first_value:value
  other_values:(ws "," ws value:value ws { return value })*
  { return { value: { array: [first_value, ...other_values] } } }

hash =
  "{" ws
  key_values:(
    first_key_value:key_value
    other_key_values:(
      ws "," ws key_value:key_value
      { return key_value }
    )*
    { return [first_key_value, ...other_key_values] }
  )?
  ws "}"
  { return key_values }

short_hash =
  first_key_value:key_value
  other_key_values:(
    ws "," ws key_value:key_value
    { return key_value }
  )*
  { return { value: { hash: [first_key_value, ...other_key_values] } } }
