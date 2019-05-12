{
  function j(string) { return string.join('') }
  function r() {
    let result = {}

    for (let i = 0; i < (arguments.length / 2); i += 1) {
      result[arguments[i * 2]] = arguments[i * 2 + 1]
    }

    return result
  }
}

template = (interpolation / tag / text)+

text =
  $(!open_interpolation !open_tag .)+

ws "whitespace" = (" " / "\n")*
value = $(!" " .)+
expression = text
variable = text

// {{ this }}
open_interpolation = "{{"
close_interpolation = "}}"

not_close_interpolation =
  ws !close_interpolation value:value ws { return value }

interpolation =
  open_interpolation
  value:not_close_interpolation+
  close_interpolation {
    return r('interpolation', j(value))
  }

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
