module VerifyHelper
  extend self

  def mobile_user(params = {})
    @user = User.find_or_initialize_by(mobile: params[:mobile])
    if @user.persisted?
      @mobile_token = @user.mobile_tokens.valid.find_by(token: params[:token])
    else
      @mobile_token = MobileToken.valid.find_by(token: params[:token], account: params[:mobile])
      @user = @mobile_token.build_user if @mobile_token
    end

    if @mobile_token
      @user.mobile_confirm = true
      @mobile_token.increment! :access_counter
    end
    @user
  end

end


