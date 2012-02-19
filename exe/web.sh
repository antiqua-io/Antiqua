#!/usr/bin/env sh
bundle exec rails s thin -p $PORT -e $RACK_ENV
