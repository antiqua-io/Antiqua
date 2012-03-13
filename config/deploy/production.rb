set :app_env          , "production"
set :application_port , "7000"
set :branch           , "production"
set :deploy_to        , "/var/www/#{ application }/#{ app_env }"
set :rails_env        , "production"
set :user             , "ubuntu"

ssh_options[ :keys ] = [ File.join( ENV[ "HOME" ] , ".ssh" , "antiqua_production.pem" ) ]

server "50.112.111.66" , :app , :web , :primary => true
