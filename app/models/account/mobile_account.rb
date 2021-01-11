class MobileAccount < Account
  include Auth::Model::Account::MobileAccount
end unless defined? MobileAccount
