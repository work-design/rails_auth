module RailsAuth::Account
  extend ActiveSupport::Concern

  included do
    attribute :type, :string
    attribute :identity, :string
    attribute :confirmed, :boolean, default: false
    attribute :primary, :boolean, default: false
    
    belongs_to :user, optional: true
    has_one :authorized_token, -> { valid }
    has_many :authorized_tokens, dependent: :delete_all
    has_many :verify_tokens, dependent: :delete_all
    has_many :oauth_users, dependent: :nullify
    
    scope :without_user, -> { where(user_id: nil) }
    scope :confirmed, -> { where(confirmed: true) }
    
    validates :identity, presence: true
    validates :identity, uniqueness: { scope: :confirmed }
    
    after_initialize if: :new_record? do
      if self.identity.to_s.include?('@')
        self.type ||= 'EmailAccount'
      else
        self.type ||= 'MobileAccount'
      end
    end
    after_save :set_primary, if: -> { self.primary? && saved_change_to_primary? }
    after_update :sync_user, if: -> { saved_change_to_user_id? }
  end

  def set_primary
    return unless user_id
    self.class.base_class.unscoped.where.not(id: self.id).where(user_id: self.user_id).update_all(primary: false)
  end
  
  def sync_user
    self.oauth_users.update_all(user_id: self.user_id)
    self.verify_tokens.update_all(user_id: self.user_id)
    self.authorized_tokens.update_all(user_id: self.user_id)
  end

  def can_login?(params = {})
    self.errors.clear
    if params[:token]
      if authenticate_by_token(params[:token])
        if user.nil?
          return join(params)
        else
          return user
        end
      else
        return false
      end
    end
    
    if user.nil?
      errors.add :base, :join_first
      return false
    end

    unless user.can_login?(params)
      user.errors.details[:base].each do |err|
        self.errors.add :base, err[:error]
      end
      return false
    end
    
    user
  end

  def authenticate_by_token(token)
    if token.blank?
      self.errors.add :base, :token_blank
      return false
    end
    
    check_token = self.check_tokens.valid.find_by(token: token)
    if check_token
      self.update(confirmed: true)
    else
      self.errors.add :base, :wrong_token
      false
    end
  end

  def join(params = {})
    if params[:device_id]
      account = ::DeviceAccount.find_by identity: params[:device_id]
      self.user = account.user if account
    end
    
    user || build_user
    user.assign_attributes params.slice(:name, :password, :password_confirmation, :invited_code)
    self.primary = true
    self.class.transaction do
      user.save!
      self.save!
    end
    
    user
  end

  def verify_token
    if check_token
      check_token
    else
      VerifyToken.transaction do
        self.check_tokens.delete_all
        create_check_token
      end
    end
  end

  def authorized_token
    if super
      super
    else
      AuthorizedToken.transaction do
        self.authorized_tokens.delete_all
        create_authorized_token
      end
    end
  end

  def auth_token
    authorized_token.token
  end
  
  def reset_token
  end
  
  def reset_notice
    p 'Should implement in subclass'
  end
  
  class_methods do
    
    def create_with_identity(identity)
      if identity.to_s.include?('@')
        ::EmailAccount.create(identity: identity)
      else
        ::MobileAccount.create(identity: identity)
      end
    end
    
  end

end
