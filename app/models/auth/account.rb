module Auth
  class Account < RailsAuthRecord
    include Model::Account
  end
end unless defined? Auth::Account
