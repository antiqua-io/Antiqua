#!/usr/bin/env sh
bundle exec rake resque:work QUEUE=$APP_ENV"_archive_deploy_key"
