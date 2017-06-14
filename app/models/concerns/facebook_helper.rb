class FacebookHelper


  def initialize
    @strategy = OmniAuth::Strategies::Facebook.new(nil, 'abc', 'efg')
  end

  def strategy
     access_token: ''
  end


end


