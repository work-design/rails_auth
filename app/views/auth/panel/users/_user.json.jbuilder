json.extract!(
  model,
  :id,
  :name,
  :timezone,
  :avatar_url,
  :auth_tokens
)
json.accounts user.accounts do |account|
  json.extract! account, :id, :identity
  json.auth_token account.auth_token
end
