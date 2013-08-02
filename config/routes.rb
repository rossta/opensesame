OpenSesame::Engine.routes.draw do
  root :to => "sessions#new"

  get '/:provider/callback', :to => 'sessions#create'
  get '/:provider/failure', :to => 'sessions#failure'
  get '/login', :to => 'sessions#new', :as => :sign_in
  get '/logout', :to => 'sessions#destroy', :as => :sign_out
end
