module Auth
  module Model::AuthorizedToken
    extend ActiveSupport::Concern

    included do
      attribute :id, :uuid
      attribute :token, :string, index: { unique: true }
      attribute :identity, :string, index: true
      attribute :expire_at, :datetime
      attribute :session_key, :string, comment: '目前在小程序下用到'
      attribute :access_counter, :integer, default: 0
      attribute :mock_member, :boolean, default: false
      attribute :mock_user, :boolean, default: false
      attribute :business, :string
      attribute :appid, :string
      attribute :uid, :string
      attribute :session_id, :string
      attribute :used_at, :datetime


      belongs_to :member, class_name: 'Org::Member', optional: true
      belongs_to :app, class_name: 'Wechat::App', foreign_key: :appid, primary_key: :appid, optional: true

      belongs_to :oauth_user, foreign_key: :uid, primary_key: :uid, optional: true
      belongs_to :account, foreign_key: :identity, primary_key: :identity, optional: true
      has_one :user, through: :account

      scope :valid, -> { where('expire_at >= ?', Time.current).order(expire_at: :desc) }
      validates :token, presence: true

      before_validation :update_token, if: -> { new_record? }
      before_validation :sync_identity, if: -> { uid.present? && uid_changed? }
      after_save_commit :prune_used, if: -> { used_at.present? && saved_change_to_used_at? }
    end

    def sync_identity
      self.identity ||= oauth_user.identity
    end

    def expired?(now = Time.current)
      return true if self.expire_at.blank?
      self.expire_at < now
    end

    def verify_token?(now = Time.current)
      return false if self.expire_at.blank?
      if now > self.expire_at
        self.errors.add(:token, 'The token has expired')
        return false
      end

      true
    end

    def update_token
      self.expire_at = 1.weeks.since
      self.token = generatex_token
      self
    end

    def update_token!
      update_token
      save
      self
    end

    def prune_used
      DisposableTokenCleanJob.perform_later(self)
    end

  end
end
