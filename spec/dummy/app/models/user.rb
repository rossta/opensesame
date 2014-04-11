class User < ActiveRecord::Base
  if defined?(Devise)
    devise :database_authenticatable, :registerable,
      :recoverable, :rememberable, :trackable, :validatable
  end
  #
  attr_accessible :email, :password, :password_confirmation, :remember_me
end
