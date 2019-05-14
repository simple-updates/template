#!/usr/bin/env bash

coffee -c parser
pegjs --trace template.pegjs
