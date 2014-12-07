module TheAuthModel
  extend ActiveSupport::Concern

  included do
    include ActiveModel::SecurePassword
    attr_accessor :remember_me
    has_secure_password validations: false

    validates :email, uniqueness: true
    before_save :auto_set_value, if: :email_changed?
  end


  private

  def auto_set_value
    if self.name.blank?
      self.name = self.email.split("@").first
    end
  end

end