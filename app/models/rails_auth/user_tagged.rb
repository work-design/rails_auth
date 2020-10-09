module RailsAuth::UserTagged
  extend ActiveSupport::Concern

  included do
    belongs_to :user_tag, counter_cache: true
    belongs_to :tagged, polymorphic: true, optional: true
  end

end
