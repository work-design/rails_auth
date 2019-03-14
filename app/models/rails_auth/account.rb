class Account < ApplicationRecord
  belongs_to :user
  after_initialize if: :new_record? do
    if self.account.include?('@')
      self.type = 'EmailAccount'
    else
      self.type = 'MobileAccount'
    end
  end

  def can_login_organ?
    confirmed? && member&.organ_token
  end

end
