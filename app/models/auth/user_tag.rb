module Auth
  class UserTag < ApplicationRecord
    include Model::UserTag
  end unless defined? Auth::UserTag
end
