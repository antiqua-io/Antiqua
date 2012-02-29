require "bundler/capistrano"
require "capistrano/ext/multistage"

$:.unshift File.expand_path( "./lib" , ENV[ "rvm_path" ] )
require "rvm/capistrano"

set :application         , "antiqua"
set :default_run_options , :pty => true
set :default_stage       , "demo"
set :deploy_via          , :remote_cache
set :repository          , "git@github.com:cookrn/Antiqua.git"
set :rvm_ruby_string     , "ruby-1.9.3-p125"
set :scm                 , :git
set :stages              , [ "demo" ]
set :use_sudo            , true

ssh_options[ :forward_agent ] = true

namespace :deploy do
  task :create_deploy_to_location , :roles => :app do
    sudo "mkdir -p #{ deploy_to }"
  end

  task :update_deploy_to_permissions , :roles => :app do
    sudo "chown -hR #{ user }:#{ user } #{ deploy_to }"
  end
end

namespace :foreman do
  desc "Export the Procfile to Ubuntu's upstart scripts"
  task :export, :roles => :app do
    environment_file = "#{ shared_path }/#{ app_env }.env"
    upstart_tmp_path = "#{ shared_path }/tmp/upstart"
    run <<COMMAND
mkdir -p #{ upstart_tmp_path } && \
rm -f #{ upstart_tmp_path }/*.conf && \
cd #{ current_path } && \
bundle exec foreman export upstart #{ upstart_tmp_path } \
  -a #{ application }-#{ app_env } \
  -e #{ environment_file } \
  -f Procfile \
  -l #{ shared_path }/log \
  -p #{ application_port } \
  -u #{ user } && \
sudo cp -f #{ upstart_tmp_path }/*.conf /etc/init
COMMAND
  end

  desc "Start the application services"
  task :start, :roles => :app do
    sudo "start #{ application }-#{ app_env }"
  end

  desc "Stop the application services"
  task :stop, :roles => :app do
    sudo "stop #{ application }-#{ app_env }"
  end

  desc "Restart the application services"
  task :restart, :roles => :app do
    run "sudo start #{ application }-#{ app_env } || sudo restart #{ application }-#{ app_env }"
  end
end

namespace :rvm do
  desc "Auto trust the app RVMRC file"
  task :trust_rvmrc , :roles => :app do
    run "rvm rvmrc trust #{ release_path }"
  end
end

after  "deploy"        , "rvm:trust_rvmrc"
before "deploy:setup"  , "deploy:create_deploy_to_location"
after  "deploy:setup"  , "deploy:update_deploy_to_permissions"
after  "deploy:update" , "foreman:export"
after  "deploy:update" , "foreman:restart"
