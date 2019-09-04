FactoryBot.define do
  factory :user_tag do
    id { 1 }
    organ_id { 1 }
    tagging_type { "MyString" }
    tagging_id { 1 }
    name { "MyString" }
    user_taggeds_count { 1 }
    created_at { "2019-09-04 17:45:41" }
    updated_at { "2019-09-04 17:45:41" }
  end
end
