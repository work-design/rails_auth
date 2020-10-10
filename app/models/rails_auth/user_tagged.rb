module RailsAuth::UserTagged
  extend ActiveSupport::Concern

  included do
    belongs_to :user_tag, counter_cache: true
    belongs_to :tagged, polymorphic: true, optional: true
    has_many :user_annunciates, foreign_key: :user_tag_id, primary_key: :user_tag_id
  end

end
