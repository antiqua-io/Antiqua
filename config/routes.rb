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

  resources :users , :only => [ :show , :update ]

  match "auth/:provider/callback" => "auth#callback"
  match "auth/failure"            => "auth#failure"
  match "auth/logout"             => "auth#logout"

  match "terms_of_service" => "static#terms_of_service"
  match "privacy_policy"   => "static#privacy_policy"
end
