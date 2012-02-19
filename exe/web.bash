#!/usr/bin/env bash
bundle exec rails s thin -p $PORT -e $RACK_ENV
