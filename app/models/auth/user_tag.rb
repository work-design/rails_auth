module Auth
  class UserTag < ApplicationRecord
    include Model::UserTag
  end
end unless defined? Auth::UserTag
