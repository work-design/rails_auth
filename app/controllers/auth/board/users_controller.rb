module Auth
  class Board::UsersController < Board::BaseController
    before_action :set_user

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
