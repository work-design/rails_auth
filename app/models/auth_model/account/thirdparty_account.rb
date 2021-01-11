module AuthModel::Account::ThirdpartyAccount
  extend ActiveSupport::Concern

  included do
    attribute :confirmed, :boolean, default: true
    validates :identity, uniqueness: { scope: :source }
  end

  def can_login?(params = {})
    if user.nil?
      join(params)
    end

    user
  end

end
