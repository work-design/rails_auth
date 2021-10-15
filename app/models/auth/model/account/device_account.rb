module Auth
  module Model::Account::DeviceAccount

    def can_login?(params = {})
      if user.nil?
        join(params)
      end

      user
    end

  end
end
