module TheAuthUser
  extend ActiveSupport::Concern

  included do
    include ActiveModel::SecurePassword
    attr_accessor :remember_me

    validates :email, uniqueness: true
    has_secure_password validations: false
    before_save :auto_set_value, if: :email_changed?
  end

  private

  def auto_set_value
    if self.name.blank?
      self.name = self.email.split("@").first
    end
  end

end

