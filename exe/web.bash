exec /usr/bin/env rvm-shell "$APP_RUBY" -c "bundle exec 'rails s thin -p $PORT -e $RACK_ENV'"
