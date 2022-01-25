module Auth
  module Model::Account::ThirdpartyAccount
    extend ActiveSupport::Concern

    included do
      attribute :confirmed, :boolean, default: true

      validates :identity, uniqueness: { scope: :source }

      # belongs_to 的 autosave 是在 before_save 中定义的
      # 
      after_validation :init_user
    end

    def init_user
      user || build_user
    end

  end
end
