class UserTagged < ApplicationRecord
  include Auth::Model::UserTagged
end unless defined? UserTagged
