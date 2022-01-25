module Auth
  module Model::Account::ThirdpartyAccount
    extend ActiveSupport::Concern

    included do
      attribute :confirmed, :boolean, default: true

      validates :identity, uniqueness: { scope: :source }

      around_create :init_user
    end

    def init_user
      user || build_user
      yield
      user.save
    end

  end
end
