# Deal with token
#
# 用于处理Token
module Auth
  module Model::VerifyToken
    extend ActiveSupport::Concern

    included do
      attribute :type, :string
      attribute :token, :string
      attribute :expire_at, :datetime
      attribute :identity, :string, index: true
      attribute :access_counter, :integer, default: 0

      belongs_to :account, foreign_key: :identity, primary_key: :identity, optional: true

      scope :valid, -> { where('expire_at >= ?', 1.minutes.since).order(expire_at: :desc) }

      validates :token, presence: true
      validates :identity, presence: true

      after_initialize :update_token, if: -> { new_record? }
      after_create_commit :clean_when_expired
    end

    def can_login_by_token?(token, **params)
      account || build_account
    end

    def clean_when_expired
      VerifyTokenCleanJob.set(wait_until: expire_at).perform_later(self)
    end

    def update_token
      self.token ||= SecureRandom.uuid
      self.expire_at ||= 14.days.since
      self
    end

    def update_token!
      update_token
      save
      self
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

    def send_out
      raise 'should implement in subclass'
    end

    def send_out!
      send_out
      save
    end

    class_methods do
      def build_with_identity(identity)
        verify_token = self.valid.find_by(identity: identity)
        return verify_token if verify_token

        type = if identity.to_s.include?('@')
          'Auth::EmailToken'
        else
          'Auth::MobileToken'
        end
        self.new(type: type, identity: identity)
      end
    end

  end
end
