module Auth
  class AuthorizedToken < RailsAuthRecord
    include Auth::Model::AuthorizedToken
  end
end
