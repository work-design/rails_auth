module TheAuth
  module Helper

    private
    def resource
      @user_class = TheAuth.config.default_user_class.constantize
    end

    def resource_name
      @user_name = TheAuth.config.default_user_class.underscore
    end

  end
end