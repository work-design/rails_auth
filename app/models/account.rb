class Account < ApplicationRecord
  include Auth::Model::Account
  def self.table_name_prefix
    'auth_'
  end
end unless defined? Account
