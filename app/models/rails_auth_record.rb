class RailsAuthRecord < ApplicationRecord
  self.abstract_class = true

  def self.table_name_prefix
    'auth_'
  end

end unless defined? RailsAuthRecord
