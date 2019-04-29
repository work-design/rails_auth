module RailsAuth::Account::MobileAccount
  extend ActiveSupport::Concern

  included do
    has_one :check_token, -> { valid }, class_name: 'MobileToken', foreign_key: :account_id
    has_many :check_tokens, class_name: 'MobileToken', foreign_key: :account_id, dependent: :delete_all
  end

  def reset_notice
    puts "sends sms here"
  end

end
