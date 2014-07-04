module TheAuth
  module User
    extend ActiveSupport::Concern

    included do
      include ActiveModel::SecurePassword
      has_secure_password validations: false
    end

  end
end