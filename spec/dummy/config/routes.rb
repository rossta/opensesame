Rails.application.routes.draw do
  root :to => "home#index"

  devise_for :users if defined?(Devise)

  mount OpenSesame::Engine => "/opensesame", :as => :opensesame
end
