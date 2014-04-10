Rails.application.routes.draw do
  root :to => "home#index"

  devise_for :users

  mount OpenSesame::Engine => "/opensesame", :as => :opensesame
end
