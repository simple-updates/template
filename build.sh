#!/usr/bin/env bash

coffee -c -o build/parser.js parser

pegjs template.pegjs \
  -O size \
  -o build/template.js \
  --trace \
  -a template \
  -f globals \
  --export-var Template
