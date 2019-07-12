class UserTagged < ApplicationRecord
  include RailsAuth::UserTagged
end unless defined? UserTagged
