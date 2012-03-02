Antiqua::Application.routes.draw do
  root :to => "static#home"

  namespace :admin do
    resources :archives     , :only => :index
    resources :repositories , :only => :index
    resources :users        , :only => :index
  end

  resources :archives     , :only => [ :create , :show ] do
    member do
      get :tar_ball
    end
  end

  resources :repositories , :only => [ :index ]

  match "auth/:provider/callback" => "auth#callback"
  match "auth/failure"            => "auth#failure"
  match "auth/logout"             => "auth#logout"

  require "resque/server" and mount Resque::Server , :at => "/_resque"
end
