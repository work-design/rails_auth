json.extract! user,
              :id,
              :name,
              :email,
              :mobile,
              :locale,
              :avatar_url
json.oauth_users user.oauth_users, :id, :provider, :uid
