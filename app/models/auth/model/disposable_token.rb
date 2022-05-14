module Auth
  module Model::DisposableToken
    extend ActiveSupport::Concern

    included do
      attribute :id, :uuid
      attribute :identity, :string, index: true
      attribute :used_at, :datetime

      belongs_to :account, foreign_key: :identity, primary_key: :identity, optional: true

      after_save_commit :prune_used, if: -> { used_at.present? && saved_change_to_used_at? }
    end

    def prune_used
      DisposableTokenCleanJob.perform_later(self)
    end

  end
end
