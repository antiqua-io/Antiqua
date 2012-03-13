# .env Files

For each deployed environment, a `.env` needs to be created. This is by
convention located in the Capistrano `shared` directory for that
deployment.

For example, for the `demo` environment, a `demo.env` file is located in
`/var/www/antiqua/demo/shared`.

## Example

```
APP_ENV=demo
APP_RUBY=ruby-1.9.3-p125
CONFIG_AIRBRAKE_API_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
CONFIG_APP_SECRET_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
CONFIG_AWS_ACCESS_KEY_ID=xxxxxxxxxxxxxxxxxxxx
CONFIG_AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
CONFIG_BASIC_AUTH_USERNAME=xxxxxxxxxxxxxxxxx
CONFIG_BASIC_AUTH_PASSWORD=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
CONFIG_GITHUB_TOKEN=xxxxxxxxxxxxxxxxxxxx
CONFIG_GITHUB_SECRET=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
CONFIG_GLOBAL_ALERT_ID=demo_warning
CONFIG_GOOGLE_ANALYTICS_ACCOUNT=xxxxxxxxxxxxx
CONFIG_GOOGLE_ANALYTICS_DOMAIN=demo.antiqua.io
CONFIG_HAS_GLOBAL_ALERT=true
CONFIG_SENDGRID_DOMAIN=demo.antiqua.io
CONFIG_SENDGRID_PASSWORD=xxxxxxxxxxxxxxxxxx
CONFIG_SENDGRID_USER_NAME=xxxxxx
CONFIG_STRIPE_INDIVIDUAL_PLAN_ID=xxxxxxxxxx
CONFIG_STRIPE_PUBLISHABLE_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
CONFIG_STRIPE_SECRET_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
CONFIG_USE_BASIC_AUTH=true
CONFIG_USE_GOOGLE_ANALYTICS=true
RACK_ENV=demo
RAILS_ENV=demo
```

## Configurable Keys

* `CONFIG_USE_BASIC_AUTH` :: If set to `true`, `CONFIG_BASIC_AUTH_USERNAME` and `CONFIG_BASIC_AUTH_PASSWORD` are required
* `CONFIG_USE_GOOGLE_ANALYTICS` :: If set to `true`, `CONFIG_GOOGLE_ANALYTICS_ACCOUNT` and `CONFIG_GOOGLE_ANALYTICS_DOMAIN` are required
* `CONFIG_HAS_GLOBAL_ALERT` :: If set to `true`, `CONFIG_GLOBAL_ALERT_ID` is required to be set to a value that matches a key in `app/lib/global_alert.rb`
