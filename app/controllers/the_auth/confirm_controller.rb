class TheAuth::ConfirmController < TheAuth::BaseController

  def update
    @token = ConfirmToken.find_by(token: params[:token])

    if @token.verify_token?
      redirect_back(fallback_location: root_url, error: @token.errors.full_messages)
    else
      redirect_back(fallback_location: root_url, error: '用户不存在')
    end
  end

end
