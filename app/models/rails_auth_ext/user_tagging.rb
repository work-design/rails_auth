module RailsAuthExt::UserTagging
  extend ActiveSupport::Concern

  included do
    has_many :user_taggeds, as: :tagged
    after_create :xx
  end

  def config_user_tag
    UserTag.find_by(tagging_type: self.class_name)
  end

  def xx
    tag = user_tag || config_user_tag
    if tag
      tagged = user.user_taggeds.find_or_initialize_by(user_tag_id: tag.id)
      tagged.save
    end
  end

end
