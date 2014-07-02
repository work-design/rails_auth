# 每次登陆后记录登陆相关信息（）
# todo warden验证用户只要验证通过，任何一种Strategies都返回同样的结果
Warden::Manager.after_set_user :except => :fetch do |record, warden, options|
  if record.respond_to?(:update_tracked_fields!) && warden.authenticated?(options[:scope])
    record.update_tracked_fields!(warden.request)
  end
end
