# coding: utf-8
require 'warden'
require_relative 'warden/warden_strategies'
require_relative 'warden/warden_hooks'

def resource_class
 @user_class = TheAuth.config.default_user_class.constantize
end

Rails.configuration.middleware.insert_after ActionDispatch::Session::CookieStore, Warden::Manager do |manager|
  manager.failure_app = TheAuth::UserSessionsController
  manager.default_scope :email
  manager.scope_defaults(
    :email,
    :strategies => [:password],
    :store => false,
    :action => "new_test"
  )
end

Warden::Strategies.add(:password, PasswordStrategy)

Warden::Manager.serialize_into_session do |user|
  user.id
end

Warden::Manager.serialize_from_session do |id|
  if id.kind_of?(Hash)
    resource_class.find id['$oid']
  else
    resource_class.find id
  end
end