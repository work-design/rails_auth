class Account < RailsAuthRecord
  include RailsAuth::Account

end unless defined? Account
