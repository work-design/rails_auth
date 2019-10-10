FactoryBot.define do
  factory :user do
    
    identity { "MyString" }
    confirmed { false }
    primary { false }
  end
  
end
