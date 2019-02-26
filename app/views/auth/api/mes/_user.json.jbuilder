json.extract! user,
              :id,
              :name,
              :email,
              :mobile,
              :mobile_confirmed,
              :locale,
              :timezone,
              :avatar_url
json.oauth_users user.oauth_users, :id, :provider, :uid
