module Auth
  class MobileAccount < Account
    include Model::Account::MobileAccount
  end unless defined? Auth::MobileAccount
end
