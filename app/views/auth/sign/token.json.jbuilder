json.message message
unless Rails.env.production?
  json.token @verify_token.token
end
