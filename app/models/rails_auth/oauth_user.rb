class OauthUser < ApplicationRecord
  attribute :refresh_token, :string
  belongs_to :user, autosave: true, optional: true
  validates :provider, presence: true
  validates :uid, presence: true, uniqueness: { scope: :provider }

  def save_info(info_params)
  end

  def strategy

  end

  def refresh_token!
    client = strategy
    token = OAuth2::AccessToken.new client, self.access_token, {expires_at: self.expires_at.to_i, refresh_token: self.refresh_token}
    token.refresh!
  end

end unless RailsAuth.config.disabled_models.include?('OauthUser')
