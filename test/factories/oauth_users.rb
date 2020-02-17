FactoryBot.define do

  factory :oauth_user do
    user
    provider { 'wechat' }
    type { 'DeveloperUser' }
    uid { "MyString" }
    name { "MyString" }
    avatar_url { "MyString" }
    state { "MyString" }
    access_token { "MyString" }
    expires_at { 1.hour.since }
  end

end
