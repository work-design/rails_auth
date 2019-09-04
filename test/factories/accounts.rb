FactoryBot.define do
  factory :account do
    id { 1 }
    user_id { 1 }
    type { "" }
    identity { "MyString" }
    confirmed { false }
    primary { false }
    created_at { "2019-09-04 12:58:30" }
    updated_at { "2019-09-04 12:58:30" }
  end
end
