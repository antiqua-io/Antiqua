Antiqua::Application.routes.draw do
  root :to => "static#home"

  resources :archives
  resources :repositories
  resources :sessions     , :only => [ :create , :destroy ]

  match "auth/:provider/callback" => "auth#callback"
  match "auth/failure"            => "auth#failure"
end
