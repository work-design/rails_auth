class MobileAccount < Account
  has_one :check_token, -> { valid }, class_name: 'MobileToken'
  has_many :check_tokens, class_name: 'MobileToken', dependent: :delete_all


end
