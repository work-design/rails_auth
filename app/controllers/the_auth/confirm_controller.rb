class TheAuth::ConfirmController < TheAuth::BaseController

  def edit
    token = ConfirmToken.find_by(token: params[:token])

    if @user.blank?
      redirect_back(fallback_location: root_url, error: '用户不存在')
    elsif @user.verify_confirm_token? && @user.email_confirm_update!
      redirect_back(fallback_location: root_url, error: @user.errors.full_messages)
    end
  end

end
