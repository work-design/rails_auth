FactoryBot.define do
  factory :authorized_token do
    user
    token { "MyString" }
    expire_at { 1.hour.since }
    session_key { "MyString" }
    access_counter { 1 }
  end
end
