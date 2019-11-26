module RailsAuth::Account::EmailAccount
  extend ActiveSupport::Concern
  included do
    has_one :check_token, -> { valid }, class_name: 'EmailToken', foreign_key: :account_id
    has_many :check_tokens, class_name: 'EmailToken', foreign_key: :account_id, dependent: :delete_all
  end
  
  def reset_notice
    UserMailer.password_reset(self).deliver_later
  end
  
  def reset_token
    authorized_token.token = SecureRandom.uuid
    authorized_token.expire_at = 10.minutes.since
    authorized_token.save
    authorized_token.token
  end
  
end
