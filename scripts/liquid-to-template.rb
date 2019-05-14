#!/usr/bin/env ruby

input = ARGV.join(' ')
input = input.gsub("{% assign ", "{% ")
puts input
