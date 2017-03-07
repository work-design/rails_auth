module TheAuthUser
  extend ActiveSupport::Concern

  included do
    include ActiveModel::SecurePassword

    validates :email, uniqueness: true, if: -> { email.present? }
    validates :mobile, uniqueness: true, if: -> { mobile.present? }
    has_secure_password validations: false
  end


  def email_confirm_update!
    update(email_confirm: true)
  end

end

