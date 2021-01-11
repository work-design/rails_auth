class User < ApplicationRecord
  include Auth::Model::User
end unless defined? User
