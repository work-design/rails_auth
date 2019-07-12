class UserTag < ApplicationRecord
  include RailsAuth::UserTag
end unless defined? UserTag
