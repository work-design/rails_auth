class SessionAccount < Account
  include RailsAuth::Account::SessionAccount
end unless defined? SessionAccount
