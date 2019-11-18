module RailsAuth::UserTagging
  extend ActiveSupport::Concern
  included do
    has_one :user_tag, as: :tagging
    after_create :xx
  end
  
  def config_user_tag
    UserTag.find_by(tagging_type: self.class_name)
  end
  
  def xx
    tag = user_tag || config_user_tag
    if tag
      tagged = user.user_taggeds.build(user_tag_id: tag.id)
      tagged.save
    end
  end
  
end
