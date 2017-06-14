class FacebookUser < OauthUser





  def stray
    OmniAuth::Strategies::Facebook.new nil, 'abc', 'efg', access_token: ''
  end

end
