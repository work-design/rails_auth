class Auth::Api::MesController < Auth::Api::BaseController
  before_action :require_logon_from_token

  def show
    render json: @user.as_json(root: true, include: [:oauth_users], methods: [:avatar_url])
  end

  def update
    if @user.update(user_params)
      render json: @user.as_json(root: true, methods: [:avatar_url]), status: :created
    else
      process_errors(@user)
    end
  end

  def destroy
    @user.destroy
    redirect_to api_me_url, notice: 'Me was successfully destroyed.'
  end

  private
  def set_user
    @user = current_user
  end

  def user_params
    params.fetch(:user, {}).permit(
      :name,
      :email,
      :mobile,
      :locale,
      :nation,
      :timezone
    )
  end

end
