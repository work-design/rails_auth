module Auth
  class AuthorizedToken < RailsAuthRecord
    include Model::AuthorizedToken
  end unless defined? Auth::AuthorizedToken
end
