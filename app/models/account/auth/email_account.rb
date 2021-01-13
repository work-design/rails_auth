module Auth
  class EmailAccount < Account
    include Auth::Model::Account::EmailAccount
  end
end
