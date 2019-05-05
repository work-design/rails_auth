module RailsAuth::OauthUser
  extend ActiveSupport::Concern

  included do
    attribute :refresh_token, :string

    belongs_to :account, optional: true
    belongs_to :user, autosave: true, optional: true
    has_one :same_oauth_user, -> (o){ where.not(id: o.id, unionid: nil, user_id: nil) }, class_name: self.name, foreign_key: :unionid, primary_key: :unionid
    has_many :same_oauth_users, -> (o){ where.not(id: o.id, unionid: nil) }, class_name: self.name, foreign_key: :unionid, primary_key: :unionid

    validates :provider, presence: true
    validates :uid, presence: true, uniqueness: { scope: :provider }
    
    before_validation do
      # todo better user sync logic
      self.user_id = self.account&.user_id if account_id_changed?
    end
  end

  def save_info(info_params)
  end

  def strategy

  end

  def refresh_token!
    client = strategy
    token = OAuth2::AccessToken.new client, self.access_token, { expires_at: self.expires_at.to_i, refresh_token: self.refresh_token }
    token.refresh!
  end

end
