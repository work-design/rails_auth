module Auth
  class User < ApplicationRecord
    include Model::User
  end
end unless defined? Auth::User
