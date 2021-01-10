module Auth
  class UserTagged < ApplicationRecord
    include Model::UserTagged
  end
end unless defined? Auth::UserTagged
