class Auth::Mine::UsersController < Auth::Mine::BaseController

  def show
  end

  def edit
  end

  def update
    current_user.assign_attributes user_params
    
    unless current_user.save
      render :edit, locals: { model: current_user }, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
  end

  private
  def user_params
    params.fetch(:user, {}).permit(
      :name,
      :avatar,
      :locale,
      :nation,
      :timezone
    )
  end

end
