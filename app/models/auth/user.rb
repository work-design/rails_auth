module Auth
  class User < ApplicationRecord
    include Model::User
  end unless defined? Auth::User
end
