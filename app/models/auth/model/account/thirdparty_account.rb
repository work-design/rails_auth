module Auth
  module Model::Account::ThirdpartyAccount
    extend ActiveSupport::Concern

    included do
      attribute :confirmed, :boolean, default: true

      validates :identity, uniqueness: { scope: :source }
    end

  end
end
