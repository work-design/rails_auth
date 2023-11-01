module Auth
  class AuthorizedToken < ApplicationRecord
    include Model::AuthorizedToken
    include Org::Ext::AuthorizedToken if defined? RailsOrg
  end
end
