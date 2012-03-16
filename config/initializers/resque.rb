require 'resque/failure/multiple'
require 'resque/failure/airbrake'
require 'resque/failure/redis'

resque_config = YAML.load_file "#{ Rails.root }/config/resque.yml"
Resque.redis  = resque_config[ Rails.env ] || resque_config[ "default" ]

Resque::Failure::Airbrake.configure do | config |
  config.api_key = CONFIG.airbrake_api_key
  config.secure  = true
end

Resque::Failure::Multiple.classes = [ Resque::Failure::Redis , Resque::Failure::Airbrake ]
Resque::Failure.backend           = Resque::Failure::Multiple
