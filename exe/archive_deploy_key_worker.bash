export QUEUE=$APP_ENV"_archive_deploy_key"
exec /usr/bin/env bash exe/_rake.bash resque:work
