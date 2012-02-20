#!/usr/bin/env bash
/usr/bin/env rvm-shell "rbx-head" -c "bundle exec bundle exec rails s thin -p "$PORT" -e "$RACK_ENV
