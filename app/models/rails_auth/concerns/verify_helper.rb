# extend self::
#   this module extended self
#
module VerifyHelper
  extend self

  def mobile_user(params = {})
    @user = User.find_or_initialize_by(mobile: params[:mobile])
    if @user.persisted?
      @mobile_token = @user.mobile_tokens.valid.find_by(token: params[:token])
    else
      @mobile_token = MobileToken.valid.find_by(token: params[:token], account: params[:mobile])
      @user = @mobile_token.build_user(mobile: params[:mobile]) if @mobile_token
    end

    if @mobile_token
      @user.mobile_confirm = true
      @mobile_token.increment! :access_counter
    end
    @user
  end

  def mobile_reset_user(params = {})
    @user = User.find_by(mobile: params[:mobile])
    if @user
      @mobile_token = @user.mobile_tokens.valid.find_by(token: params[:token])
      return true if @mobile_token
    else
      false
    end
  end

end


