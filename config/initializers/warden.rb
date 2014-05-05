# coding: utf-8
require 'warden'

Rails.configuration.middleware.insert_after ActionDispatch::Session::CookieStore, Warden::Manager do |manager|
  manager.default_strategies  :password  # 就写最常用的鉴权方式
  manager.failure_app = Auth::UserSessionsController
  manager.scope_defaults(
    :email,
    :strategies => [:password],
    :store => false,
    :action => "new_test"
  )
end

Warden::Manager.serialize_into_session do |user|
  user.id
end

Warden::Manager.serialize_from_session do |id|
  User.find id
end

# 使用密码登陆
Warden::Strategies.add(:password) do
  def valid?
    params['user']
  end
  def authenticate!

    login = params['user']['email']
    if login.include?('@')
      u = User.find_by(:email => login)
    else
      u = User.find_by(:mobile => login)
    end

    if u.nil?
      fail! "该账号未注册"
      errors.add :password, '手机号未注册'
    elsif u.password_digest.nil?
      fail! "请继续完成注册"
      errors.add :password, '密码不存在，注册未完成'
      errors.add :code, 429
    else
      user = u.try(:authenticate, params['user']['password'])
      if user
        success!(user)
      else
        fail! "登陆失败"
        errors.add :password, '密码错误，请检查密码或用户名'
        errors.add :code, 450
      end
    end

  end
end

# 使用签名验证用户
Warden::Strategies.add(:access_token) do
  def valid?
    env['HTTP_ACCESS_TOKEN']
  end
  def authenticate!
    u = User.find_by(access_token: env['HTTP_ACCESS_TOKEN'])
    if u.nil?
      fail! "access_token 授权失败"  # 客户端需处理并转到密码登陆界面
      errors.add :code, 429
      errors.add :info, 'access_token 授权失败'
    else
      success!(u)
    end
  end
end

# 使用 open_id 验证用户
Warden::Strategies.add(:open_id) do
  def valid?
    params['open_id']
  end
  def authenticate!
    u = UserWeibo.find_by(open_id: params['open_id']).try(:user)
    if u.nil?
      fail!("第三方授权失败")   # 客户端需处理并转到密码登陆界面
      errors.add :open_id, '微博用户不存在，请完成注册'
      errors.add :code, 432
    else
      success!(u)
    end
  end
end

# 每次登陆后记录登陆相关信息（）
# todo warden验证用户只要验证通过，任何一种Strategies都返回同样的结果
Warden::Manager.after_set_user :except => :fetch do |record, warden, options|
  if record.respond_to?(:update_tracked_fields!) && warden.authenticated?(options[:scope])
    record.update_tracked_fields!(warden.request)
  end
end
