#!/usr/bin/env bash
set -o errexit

bundle exec puma -C config/puma.rb
