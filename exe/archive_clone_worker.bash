#!/usr/bin/env bash
/usr/bin/env rvm-shell "$APP_RUBY" -c "bundle exec rake resque:work QUEUE="$APP_ENV"_archive_clone"
