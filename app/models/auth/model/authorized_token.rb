module Auth
  module Model::AuthorizedToken
    extend ActiveSupport::Concern

    included do
      attribute :id, :uuid
      attribute :identity, :string, index: true
      attribute :expire_at, :datetime
      attribute :session_key, :string, comment: '目前在小程序下用到'
      attribute :access_counter, :integer, default: 0
      attribute :mock_member, :boolean, default: false
      attribute :mock_user, :boolean, default: false
      attribute :business, :string
      attribute :uid, :string
      attribute :session_id, :string

      belongs_to :member, class_name: 'Org::Member', optional: true

      belongs_to :oauth_user, foreign_key: :uid, primary_key: :uid, optional: true
      belongs_to :account, foreign_key: :identity, primary_key: :identity, optional: true
      has_one :user, through: :account

      has_many :sames, ->(o) { where(o.filter_hash) }, class_name: self.name, primary_key: :identity, foreign_key: :identity

      scope :valid, -> { where('expire_at >= ?', Time.current).order(expire_at: :desc) }

      after_initialize :init_expire_at, if: :new_record?
      before_validation :sync_identity, if: -> { uid.present? && uid_changed? }
    end

    def filter_hash
      {
        uid: self.uid,
        session_key: self.session_key,
        session_id: self.session_id
      }
    end

    def refresh
      self.class.transaction do
        r = sames.create!
        self.destroy!
        r
      end
    end

    def init_expire_at
      self.expire_at = 1.weeks.since
    end

    def sync_identity
      self.identity ||= oauth_user.identity
    end

    def expired?(now = Time.current)
      return true if self.expire_at.blank?
      self.expire_at < now
    end

    def effective?(now = Time.current)
      expire_at.present? && expire_at > now
    end

    def verify_token?(now = Time.current)
      return false if self.expire_at.blank?
      if now > self.expire_at
        self.errors.add(:token, 'The token has expired')
        return false
      end

      true
    end

  end
end
