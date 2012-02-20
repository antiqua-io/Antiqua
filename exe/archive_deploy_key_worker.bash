#!/usr/bin/env bash
/usr/bin/env rvm-shell "rbx-head" -c "bundle exec rake resque:work QUEUE="$APP_ENV"_archive_deploy_key"
