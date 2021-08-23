module Auth
  class Panel::AppsController < Panel::BaseController
    before_action :set_new_app, only: [:new, :create]
    before_action :set_app, only: [:show, :edit, :update, :destroy]

    def index
      @apps = App.page(params[:page])
    end

    private
    def set_app
      @app = App.find(params[:id])
    end

    def set_new_app
      @app = App.new(app_params)
    end

    def app_params
      params.fetch(:app, {}).permit(
        :appid,
        :jwt_key
      )
    end

  end
end
