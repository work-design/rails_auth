module RailsAuth::UserTag
  extend ActiveSupport::Concern
  included do
    attribute :name, :string
    attribute :user_taggeds_count, :integer, default: 0
    attribute :user_tagging, :string

    belongs_to :organ, optional: true
    belongs_to :tagging, polymorphic: true
    has_many :user_taggeds, dependent: :destroy
  end
  
end
