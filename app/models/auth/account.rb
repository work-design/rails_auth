module Auth
  class Account < ApplicationRecord
    include Model::Account
    include Org::Ext::Account if defined? RailsOrg
  end
end
