module RailsAuth::UserTag
  extend ActiveSupport::Concern
  included do
    attribute :name, :string
    attribute :user_taggeds_count, :integer, default: 0
    
    has_many :user_taggeds, dependent: :destroy
    has_many :users, through: :user_taggeds
  end
  
end
