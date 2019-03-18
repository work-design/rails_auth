json.extract! account,
              :id,
              :account,
              :confirmed,
              :primary
if account.member
  json.member account.member, :id, :organ_id
end
