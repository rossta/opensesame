OpenSesame::Engine.routes.draw do
  root :to => "sessions#new"

  match '/auth/callback', :to => 'sessions#create'
  match '/auth/failure', :to => 'sessions#failure'
  match '/login', :to => 'sessions#new', :as => :sign_in
  match '/logout', :to => 'sessions#destroy', :as => :sign_out
end
