module Auth
  class User < ApplicationRecord
    include Auth::Model::User
  end
end
