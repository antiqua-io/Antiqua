Antiqua::Application.routes.draw do
  root :to => "static#home"

  resources :archives     , :only => [ :create ]
  resources :repositories , :only => [ :index ]

  match "auth/:provider/callback" => "auth#callback"
  match "auth/failure"            => "auth#failure"
end
