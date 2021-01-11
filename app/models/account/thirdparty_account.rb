class ThirdpartyAccount < Account
  include Auth::Model::Account::ThirdpartyAccount
end unless defined? ThirdpartyAccount
