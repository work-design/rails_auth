FactoryBot.define do
  factory :email_token do
    id { 1 }
    user_id { 1 }
    type { "" }
    token { "111111" }
    expire_at { "2019-03-08 15:07:22" }
    account { "MyString" }
    access_counter { 1 }
    created_at { "2019-03-08 15:07:22" }
    updated_at { "2019-03-08 15:07:22" }
  end
end
