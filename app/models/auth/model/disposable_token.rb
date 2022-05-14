module Auth
  module Model::DisposableToken
    extend ActiveSupport::Concern

    included do
      attribute :id, :uuid
      attribute :identity, :string, index: true
      attribute :used_at, :datetime

      belongs_to :account, foreign_key: :identity, primary_key: :identity, optional: true
    end

  end
end
