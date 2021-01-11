class UserTag < ApplicationRecord
  include Auth::Model::UserTag
end unless defined? UserTag
