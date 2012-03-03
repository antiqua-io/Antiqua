export QUEUE=$APP_ENV"_archive_tar_ball"
exec /usr/bin/env bash exe/_rake.bash resque:work
