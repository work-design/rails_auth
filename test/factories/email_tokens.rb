FactoryBot.define do
  
  factory :email_token do
    type { 'EmailToken' }
    token { '111111' }
    expire_at { 1.hour.since }
    identity { 'test@work.design' }
  end
  
end
