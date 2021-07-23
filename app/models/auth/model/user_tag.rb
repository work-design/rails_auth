module Auth
  module Model::UserTag
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :user_taggeds_count, :integer, default: 0

      belongs_to :organ, optional: true
      belongs_to :user_tagging, polymorphic: true, optional: true

      has_many :user_taggeds, dependent: :destroy
      has_many :users, through: :user_taggeds

      validates :name, presence: true
    end

  end
end
