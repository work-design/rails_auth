FactoryBot.define do
  factory :oauth_user do
    id { 1 }
    user_id { 1 }
    provider { "MyString" }
    type { "" }
    uid { "MyString" }
    name { "MyString" }
    avatar_url { "MyString" }
    state { "MyString" }
    code { "MyString" }
    access_token { "MyString" }
    expires_at { "2018-09-20 10:20:04" }
    created_at { "2018-09-20 10:20:04" }
    updated_at { "2018-09-20 10:20:04" }
  end
end
