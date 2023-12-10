module Auth
  class My::UsersController < Board::UsersController
    include Controller::My
    before_action :set_user

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
