module Auth
  class AuthorizedToken < ApplicationRecord
    include Model::AuthorizedToken
    include Org::Ext::AuthorizedToken if defined? RailsOrg
    include Wechat::Ext::AuthorizedToken if defined? RailsWechat
  end
end
