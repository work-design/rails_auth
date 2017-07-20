class OauthUser < ApplicationRecord
  belongs_to :user, autosave: true
  validates :provider, presence: true
  validates :uid, presence: true, uniqueness: { scope: :provider }

  def init_user
    unless user
      _user = self.build_user
      _user.name = self.name
    end
  end

  def save_info(info_params)
  end

end
