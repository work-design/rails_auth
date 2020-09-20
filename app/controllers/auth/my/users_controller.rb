class Auth::My::UsersController < Auth::Board::UsersController
  before_action :set_user

  def show
  end

  def edit
  end

  def update
    current_user.assign_attributes user_params

    if current_user.save
      render 'create', locals: { return_to: params[:return_to].presence || my_user_path }
    else
      render :edit, locals: { model: current_user }, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.destroy
  end

  private
  def set_user
    @user = current_user
  end

  def user_params
    params.fetch(:user, {}).permit(
      :name,
      :avatar,
      :locale,
      :plate_number,
      :timezone
    )
  end

end
