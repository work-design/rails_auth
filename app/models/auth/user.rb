module Auth
  class User < RailsAuthRecord
    include AuthModel::User
  end
end
