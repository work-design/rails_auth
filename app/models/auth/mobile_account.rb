module Auth
  class MobileAccount < Account
    include Model::Account::MobileAccount
  end
end unless defined? Auth::MobileAccount
