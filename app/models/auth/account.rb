module Auth
  class Account < RailsAuthRecord
    include Model::Account
  end unless defined? Auth::Account
end
