module Auth
  class AuthorizedTokenOnlineJob < ApplicationJob

    def perform(authorized_token)
      authorized_token.trigger_online
    end

  end
end
