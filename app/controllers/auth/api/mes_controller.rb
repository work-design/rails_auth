class Auth::Api::MesController < Auth::Api::BaseController


  def show
    render json: current_user.as_json(root: true, include: [:oauth_users], methods: [:avatar_url])
  end

  def edit
  end

  def update
    if current_user.update(user_params)
      render json: current_user.as_json(root: true, methods: [:avatar_url]), status: :created
    else
      render json: current_user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @me.destroy
    redirect_to mes_url, notice: 'Me was successfully destroyed.'
  end

  private
  def user_params
    params.fetch(:user, {}).permit!
  end

end
