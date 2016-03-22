module TheAuthUser
  extend ActiveSupport::Concern

  included do
    include ActiveModel::SecurePassword
    attr_accessor :remember_me

    validates :email, uniqueness: true, if: -> { email.present? }
    has_secure_password validations: false
  end

end

