json.extract! account,
              :id,
              :identity,
              :confirmed,
              :primary
json.members account.members, :id, :organ_id, :organ_token
