export QUEUE=$APP_ENV"_archive_clean"
exec /usr/bin/env bash exe/_rake.bash resque:work
