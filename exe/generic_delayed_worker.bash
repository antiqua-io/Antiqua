export QUEUE=$APP_ENV"_generic_delayed"
exec /usr/bin/env bash exe/_rake.bash resque:work
