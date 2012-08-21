Rails.application.routes.draw do
  root :to => "home#index"

  mount OpenSesame::Engine => "/opensesame", :as => :opensesame
end
