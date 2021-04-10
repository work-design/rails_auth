module Auth
  class UserCopyAvatarJob < ApplicationJob

    def perform(oauth_user)
      user = oauth_user.user

      if user
        user.name ||= oauth_user.name
        if user.avatar.blank?
          user.avatar.url_sync(oauth_user.avatar_url)
        end
        user.save
      end
    end

  end
end
