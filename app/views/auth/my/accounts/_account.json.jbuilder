json.extract! account,
              :id,
              :identity,
              :confirmed,
              :primary
if account.member
  json.member account.member,
              :id,
              :organ_id,
              :organ_token
end
