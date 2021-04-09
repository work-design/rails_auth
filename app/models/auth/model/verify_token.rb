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

      belongs_to :account, foreign_key: :identity, primary_key: :identity

      scope :valid, -> { where('expire_at >= ?', Time.now).order(expire_at: :desc) }

      validates :token, presence: true

      after_initialize :update_token, if: -> { new_record? }
      after_create_commit :clean_when_expired
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

    class_methods do
      def create_with_account(identity)
        verify_token = self.valid.find_by(identity: identity)
        return verify_token if verify_token
        verify_token = self.new(identity: identity)
        self.transaction do
          self.where(identity: identity).delete_all
          verify_token.save!
        end
        verify_token
      end
    end

  end
end
