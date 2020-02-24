class ThirdpartyAccount < Account
  include RailsAuth::Account::ThirdpartyAccount
end unless defined? ThirdpartyAccount
