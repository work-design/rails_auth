class FacebookUser < OauthUser


  def save_info(info_params)
    self.provider = 'facebook'
    self.name = info_params['name']
  end

  def init_email

  end


  def stray
    OmniAuth::Strategies::Facebook.new nil, 'abc', 'efg', access_token: ''
  end

end
