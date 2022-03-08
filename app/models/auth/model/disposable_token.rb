module Auth
  module Model::DisposableToken
    extend ActiveSupport::Concern

    included do
      attribute :token, :string, index: { unique: true }
      attribute :identity, :string, index: true
      attribute :used_at, :datetime

      belongs_to :account, foreign_key: :identity, primary_key: :identity, optional: true

      validates :token, presence: true

      before_validation :update_token, if: -> { new_record? }
    end

    def update_token
      self.token = SecureRandom.alphanumeric
    end

  end
end
