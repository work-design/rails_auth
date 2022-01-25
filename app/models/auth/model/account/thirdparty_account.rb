module Auth
  module Model::Account::ThirdpartyAccount
    extend ActiveSupport::Concern

    included do
      attribute :confirmed, :boolean, default: true

      validates :identity, uniqueness: { scope: :source }

      before_save :init_user
    end

    def init_user
      user || build_user
      logger.debug 'ddkdkdkdkdkdkdkdkd'
    end

  end
end
