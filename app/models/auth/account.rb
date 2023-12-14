module Auth
  class Account < ApplicationRecord
    include Model::Account
    include Org::Ext::Account if defined? RailsOrg
    include Wechat::Ext::Account if defined? RailsWechat
    include Profiled::Ext::Account if defined? RailsProfiled
    include Crm::Ext::Account if defined? RailsCrm
  end
end
