class TheAuth::UsersController < TheAuth::BaseController

    def new
      @user = resource_class.new :password => ''
      referer = request.headers['X-XHR-Referer'] || request.referer
      store_location referer if referer.present?
    end

    def create
      @user = resource_class.new user_params
      if @user.save
        login_as @user
        redirect_back_or_default
      else
        render :new, :error => @user.errors.full_messages
      end
    end

    private

    def user_params
      params.require(resource_name).permit(:name, :email, :password, :password_confirmation)
    end

end
