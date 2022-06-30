module Auth
  class My::UsersController < Board::UsersController
    before_action :set_user

    def update
      @user.assign_attributes user_params

      if @user.save
        render 'create', locals: { return_to: params[:return_to].presence || my_user_path }
      else
        render :edit, locals: { model: current_user }, status: :unprocessable_entity
      end
    end

    def destroy
      @user.destroy
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
end
