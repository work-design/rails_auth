module Auth
  module Model::Account::MobileAccount
    extend ActiveSupport::Concern

    def reset_notice
      puts 'sends sms here'
    end

    def reset_token
      authorized_token.token = rand(10000..999999)
      authorized_token.expire_at = 1.hour.since
      authorized_token.save
      authorized_token.token
    end

  end
end
