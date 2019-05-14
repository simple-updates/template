#!/usr/bin/env bash

coffee -c -o $(dirname "$0")/build/parser.js parser

pegjs $(dirname "$0")/template.pegjs \
  -O size \
  -o $(dirname "$0")/build/template.js \
  --trace \
  -a template \
  -f globals \
  --export-var Template
