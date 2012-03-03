original_args=$@
exec /usr/bin/env rvm-shell "$APP_RUBY" -c "bundle exec 'rake $original_args'"
