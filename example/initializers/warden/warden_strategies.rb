# coding: utf-8
# 使用密码登陆

class PasswordStrategy < Warden::Strategies::Base

  def valid?
    params['user']
  end

  def authenticate!

    login = params['user']['email']

    if login.include?('@')
      u = resource_class.find_by(:email => login)
    else
      u = resource_class.find_by(:mobile => login)
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
