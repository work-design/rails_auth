module Auth
  class OauthUser < ApplicationRecord
    include Auth::Model::OauthUser
  end
end
