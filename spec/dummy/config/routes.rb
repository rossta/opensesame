Rails.application.routes.draw do
  root :to => "home#index"

  mount OpenSesame::Engine => "/welcome", :as => :opensesame
end
