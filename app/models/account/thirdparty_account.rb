module Auth
  class ThirdpartyAccount < Account
    include Model::Account::ThirdpartyAccount
  end unless defined? Auth::ThirdpartyAccount
end
