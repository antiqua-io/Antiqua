Antiqua::Application.routes.draw do
  root :to => "static#home"

  resources :archives     , :only => [ :create , :show ]
  resources :repositories , :only => [ :index ]

  match "auth/:provider/callback" => "auth#callback"
  match "auth/failure"            => "auth#failure"

  require "resque/server" and mount Resque::Server , :at => "/_resque"
end
