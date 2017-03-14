module TheAuthUser
  extend ActiveSupport::Concern

  included do
    include ActiveModel::SecurePassword

    validates :email, uniqueness: true, if: -> { email.present? && email_changed? }
    validates :mobile, uniqueness: true, if: -> { mobile.present? && mobile_changed? }
    has_secure_password validations: false

    has_one :confirm_token
    has_one :reset_token
    has_one :mobile_token
  end

  def email_confirm_update!
    update(email_confirm: true)
  end

end

