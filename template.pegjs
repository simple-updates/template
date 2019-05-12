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

template =
  (
    interpolation /
    tag /
    text2
  )+

text2 =
  (!open_tag .)+
  // (!open_interpolation !open_tag .)+

ws = (" " / "\n")*
value = [^ ]
expression = text2
variable = text2

// {{ this }}
open_interpolation = "{{"
close_interpolation = "}}"

not_close_interpolation =
  ws !close_interpolation m:value ws { return m }

interpolation =
  open_interpolation m:not_close_interpolation+ close_interpolation { return { 'interpolation': j(m) } }

// {% this %}
open_tag = "{%"
close_tag = "%}"

not_close_tag =
  ws !close_tag m:value ws { return m }

// tag_end open_tag m:not_close_tag+ close_tag { return j(m) }

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
