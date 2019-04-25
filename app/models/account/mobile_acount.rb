class MobileAccount < Account
  include RailsAuth::Account::MobileAccount
end unless defined? MobileAccount
