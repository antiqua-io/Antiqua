export QUEUE=$APP_ENV"_archive_upload"
exec /usr/bin/env bash exe/_rake.bash resque:work
