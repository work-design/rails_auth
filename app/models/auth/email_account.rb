module Auth
  class EmailAccount < Account
    include Model::Account::EmailAccount
  end unless defined? Auth::EmailAccount
end
