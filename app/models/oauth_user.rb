class OauthUser < ApplicationRecord
  belongs_to :user, autosave: true

  def init_user
    unless user
      _user = self.build_user
      _user.email = self.init_email
      _user.name = self.name
    end
  end

  def init_email
    email
  end

  def save_info(info_params)
  end


end
