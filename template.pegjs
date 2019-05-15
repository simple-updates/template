template = (interpolation / tag / text)+

_ = (space / newline)*

// syntax
space = " "
newline = "\n"
open_start = "{"
open_interpolation = "{{"
close_interpolation = "}}"
open_tag = "{%"
close_tag = "%}"
single_quote = "'"
double_quote = '"'
open_hash = "{"
close_hash = "}"
open_array = "["
close_array = "]"
comma = ","
key_value_separator = ":"
dot = "."
filter_separator = "|"

escape = "\\"
nil = "null"
true = "true"
false = "false"
minus = "-"
plus = "+"
equal = "="
if_ = "if"
elsif = "elsif"
else_ = "else"
endif = "endif"
for = "for"
in = "in"
endfor = "endfor"
end = "end"
e = "e" / "E"
integer_separator = "_"

digit = [0-9]+

special =
  space /
  newline /
  open_tag /
  close_tag /
  single_quote /
  double_quote /
  minus /
  plus /
  equal /
  open_hash /
  close_hash /
  open_array /
  close_array /
  comma /
  key_value_separator /
  dot /
  filter_separator

name =
  $(
    (!special .)
    (
      dot /
      (!special .)
    )*
  )

integer = $(digit (digit / integer_separator)*)

float = minus? integer dot integer (e (plus / minus) integer)

single_quoted_string =
  single_quote
  (
    !single_quote . /
    escape single_quote
  )*
  single_quote

double_quoted_string =
  double_quote
  (
    !double_quote . /
    escape double_quote
  )*
  double_quote

string = $(single_quoted_string / double_quoted_string)

key = name / string

boolean = true / false

interpolation =
  open_interpolation _
  value:(
    short_hash /
    short_array /
    value
  ) _
  filters:filter* _
  close_interpolation
  { return { 'interpolation': { filters, value } } }

tag =
  tag:(
    if_:full_if_tag
    { return { 'if': if_ } } /
    for_:full_for_tag
    { return { 'for': for_ } } /
    assign:assign_tag
    { return { assign } } /
    other:full_other_tag
    { return { other } }
  ) { return { tag } }

text =
  text:$(
    (!open_start .) /
    (!open_interpolation !open_tag open_start)
  )+
  { return { text } }

filter =
  filter_separator _
  method:name _
  parameters:parameters
  { return { method, parameters } }

parameters =
  (
    value:(
      short_hash /
      short_array /
      value
    ) _
    { return { value } }
  )*

assign_tag =
  open_tag _
  variable:name _
  equal _
  value:value _
  filters:filter* _
  close_tag
  { return { variable, value, filters } }

full_if_tag =
  if_value:if_tag
  elsif_values:elsif_tag*
  else_value:else_tag?
  endif_tag
  { return { 'if': if_value, 'elsif': elsif_values, 'else': else_value } }

full_other_tag =
  other:other_tag
  endother_tag
  { return other }

full_for_tag =
  for_value:for_tag
  template:template?
  endfor_tag
  { return { 'for': for_value, template: template } }

if_tag =
  open_tag _
  if_ _
  value:value _
  filters:filter* _
  close_tag
  template:template?
  { return { value, filters, template } }

elsif_tag =
  open_tag _
  elsif _
  value:value _
  filters:filter* _
  close_tag
  template:template?
  { return { value, filters, template } }

else_tag =
  open_tag _
  else_ _
  close_tag
  template:template?
  { return { template } }

endif_tag = open_tag _ endif _ close_tag

other_tag =
  open_tag _
  name:name _
  value:value? _
  filters:filter* _
  close_tag
  template:template?
  { return { name, value, filters, template } }

endother_tag =
  open_tag _
  end _
  close_tag

for_tag =
  open_tag _
  for _
  variable:name _
  in _
  value:value _
  filters:filter* _
  close_tag
  template:template?
  { return { variable, value, filters, template } }

endfor_tag =
  open_tag _
  endfor _
  close_tag

value =
  value:(
    array:array _
    { return { array } } /
    hash:hash _
    { return { hash } } /
    string:string _
    { return { string } } /
    boolean:boolean _
    { return { boolean } } /
    integer:integer _
    { return { integer } } /
    float:float _
    { return { float } } /
    nil:nil _
    { return { nil } } /
    variable:name _
    { return { variable } }
  )

key_value =
  key:key _
  key_value_separator _
  value:value
  { return { key, value } }

array =
  open_array _
  values:(
    first_value:value _
    other_values:(
      comma _
      value:value _
      { return value }
    )*
    { return [first_value, ...other_values] }
  )?
  close_array
  { return values }

short_array =
  first_value:value _
  other_values:(
    comma _
    value:value _
    { return value }
  )+
  { return { array: [first_value, ...other_values] } }

hash =
  open_hash _
  key_values:(
    first_key_value:key_value _
    other_key_values:(
      comma _
      key_value:key_value _
      { return key_value }
    )*
    { return [first_key_value, ...other_key_values] }
  )?
  close_hash
  { return key_values }

short_hash =
  first_key_value:key_value _
  other_key_values:(
    comma _
    key_value:key_value _
    { return key_value }
  )*
  { return { hash: [first_key_value, ...other_key_values] } }
