#!/usr/bin/env ruby

require 'pp'

system("canopy template.peg --lang ruby")

require './template.rb'

tree = Template.parse('{{ "hello" }} {{ "world" }}')

tree.elements.each do |node|
  pp [node.offset, node.text, node.elements.to_s[0..100] + "..."]
end


