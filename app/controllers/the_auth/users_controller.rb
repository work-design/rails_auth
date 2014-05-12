require_dependency "the_auth/application_controller"

module TheAuth
  class UsersController < ApplicationController

    def new
      @user = resource.new :password => '' # force client side validation patch
      referer = request.headers['X-XHR-Referer'] || request.referer
      store_location referer if referer.present?
    end

    def create
      @user = resource.new user_params
      if @user.save
        env['warden'].set_user(@user)
        redirect_to root_url
      else
        render :new, :error => @user.errors.full_messages
      end
    end

    private

    def user_params
      params.require(resource_name).permit(:name, :email, :password, :password_confirmation)
    end

  end
end
