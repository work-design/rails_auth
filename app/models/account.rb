class Account < RailsAuthRecord
  include Auth::Model::Account
end unless defined? Account
