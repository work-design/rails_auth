class Account < RailsAuthRecord
  belongs_to :user
  has_many :verify_tokens, ->(o){ where(identity: o.identity) }, primary_key: :user_id, foreign_key: :user_id
  after_initialize if: :new_record? do
    if self.identity.include?('@')
      self.type = 'EmailAccount'
    else
      self.type = 'MobileAccount'
    end
  end

  def can_login?(params)
    if user.verified_status?
      return false
    end

    if params[:password].present? && user.password_digest?
      if user.authenticate(params[:password])
        user
      else
        user.errors.add :base, :wrong_name_or_password
        return false
      end
    elsif params[:token].present?
      if authenticate_by_token(params[:token])
        user
      else
        user.errors.add :base, :wrong_token
        return false
      end
    else
      user.errors.add :base, :token_blank
      false
    end
  end

  def authenticate_by_token(token)
    verify_token = self.verify_tokens.valid.find_by(token: token)
    if verify_token
      self.update(confirmed: true)
    else
      false
    end
  end

end
