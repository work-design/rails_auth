module RailsAuth::UserTag
  extend ActiveSupport::Concern
  included do
    attribute :name, :string
    attribute :user_taggeds_count, :integer
  end
  
end
