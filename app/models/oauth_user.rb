class OauthUser < ApplicationRecord
  belongs_to :user, autosave: true

  def save_info(info_params)
    if self.provider == 'github'
      self.name = info_params['name']
      #self.email = info_params['email']
    end
  end

  def init_user
    _user = self.build_user
    _user.email = self.init_email
    _user.name = self.name
  end

  def init_email
    email
  end

end
