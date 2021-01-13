module Auth
  class User < RailsAuthRecord
    include Auth::Model::User
  end
end
