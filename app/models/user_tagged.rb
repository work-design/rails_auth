module Auth
  class UserTagged < ApplicationRecord
    include Model::UserTagged
  end unless defined? Auth::UserTagged
end
