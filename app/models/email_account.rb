class EmailAccount < Account
  include Auth::Model::Account::EmailAccount

end unless defined? EmailAccount
