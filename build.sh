#!/usr/bin/env bash

coffee -c parser.coffee
pegjs --trace template.pegjs
