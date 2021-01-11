class User < RailsAuthRecord
  include Auth::Model::User

end unless defined? User
