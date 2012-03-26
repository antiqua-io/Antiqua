export QUEUE=$APP_ENV"_user_organization_authorization"
exec /usr/bin/env bash exe/_rake.bash resque:work
