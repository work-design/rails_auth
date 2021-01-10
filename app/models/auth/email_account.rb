module Auth
  class EmailAccount < Account
    include Model::Account::EmailAccount
  end
end unless defined? Auth::EmailAccount
