module Auth
  class AuthorizedToken < RailsAuthRecord
    include Model::AuthorizedToken
  end
end unless defined? Auth::AuthorizedToken
