module RailsAuth::UserTag
  extend ActiveSupport::Concern
  included do
    attribute :name, :string
  end
  
end
