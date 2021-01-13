module Auth
  class Account < RailsAuthRecord
    include Auth::Model::Account
  end
end
