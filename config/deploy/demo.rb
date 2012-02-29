set :app_env          , "demo"
set :application_port , "7000"
set :branch           , "master"
set :deploy_to        , "/var/www/#{ application }/#{ app_env }"
set :rails_env        , "demo"
set :user             , "ubuntu"

ssh_options[ :keys ] = [ File.join( ENV[ "HOME" ] , ".ssh" , "antiqua_demo.pem" ) ]

server "50.112.109.118" , :app , :web , :primary => true
