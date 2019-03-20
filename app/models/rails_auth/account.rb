class Account < ApplicationRecord
  belongs_to :user
  after_initialize if: :new_record? do
    if self.identity.include?('@')
      self.type = 'EmailAccount'
    else
      self.type = 'MobileAccount'
    end
  end

end
