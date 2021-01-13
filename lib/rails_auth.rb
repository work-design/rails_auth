require 'rails_auth/version'
require 'rails_auth/engine'
require 'rails_auth/config'

module Auth
  def self.table_name_prefix
    ''
  end
end
