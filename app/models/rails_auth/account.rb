class Account < ApplicationRecord
  belongs_to :user

  def can_login_organ?
    confirmed? && member&.organ_token
  end

end
