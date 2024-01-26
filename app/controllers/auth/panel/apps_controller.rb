module Auth
  class Panel::AppsController < Panel::BaseController

    private
    def app_permit_params
      [
        :appid,
        :key
      ]
    end

  end
end
