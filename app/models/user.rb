class User < ApplicationRecord
  include RailsAuth::User
end unless defined? User
