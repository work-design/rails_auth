class EmailAccount < Account
  has_one :check_token, -> { valid }, class_name: 'EmailToken'
  has_many :check_tokens, class_name: 'EmailToken', dependent: :delete_all

end
