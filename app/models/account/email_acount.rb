class EmailAccount < Account
  include RailsAuth::Account::EmailAccount
end unless defined? EmailAccount
