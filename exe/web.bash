#!/usr/bin/env bash
/usr/bin/env rvm-shell "$APP_RUBY" -c "bundle exec rails s puma -p $PORT -e $RACK_ENV"
