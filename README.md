
`the_auth`是更容易使用的鉴权功能，基于`rails engine` 和 `warden`创建。
鉴权的gem很多，我写这个gem主要出于以下考虑：

- 更容易理解和学习：
`devise`虽然强大，但是过于复杂，且难于配置，对新手非常不友好；

- 更容易配置：
`the_auth`实际是将鉴权相关的controller、view、mailer、models剥离出来放到一个模块之中，使用的时候只需要按照正常开发rails的思路去配置路由
include相应的模块进来即可。

- 更容易覆盖：
想扩展的话，只需要简单地覆盖掉相应地方法，想自定义view，直接覆盖响应的view就可以，真是随心所欲。

- 基于`warden`：
`warden`是一个优秀的鉴权相关的middleware，其功能主要有三块比较强大，1、session缓存，2、登陆回调，3、scope的鉴权策略配置；

- 基于`ActiveModel::SecurePassword`：
`rails`自带，只需要一行代码就搞定密码验证，且提供的是比较前沿和安全的方案；

## 使用说明

#### 配置`the_auth`

```ruby
TheAuth.configure do |config|
  config.layout = :application  # the_auth view 的layout
  config.default_user_class = 'StatsUser'  # 需要添加鉴权功能的 user 模型
  config.access_denied_method  = :access_denied  # define it in ApplicationController
  config.login_required_method = :authenticate_user!  # devise auth method
end
```

#### 配置`warden`

参考 example 文件夹下地代码示例
更多参见warden的wiki，[warden](https://github.com/hassox/warden/wiki)


#### 配置`routes`

将`the_auth`视作一个模块，直接定义模块路由

```ruby
scope :module => :the_auth do
  get 'signup' => 'users#new', :as => :signup  # 必须
  get 'login' => 'user_sessions#new', :as => :login  # 必须
  delete 'logout' => 'user_sessions#destroy', :as => :logout  # 必须
  resource :user
  resource :user_session, :only => [:create]
  resource :password
end
```

#### 集成到controller

在 Application controller 中`include TheAuth::Controller`

```ruby
class ApplicationController < ActionController::Base
  include TheAuth::Controller

  protect_from_forgery with: :exception

  helper_method :current_user

end
```

#### 集成到model

在 User model 中 `include TheAuth::Model`

```ruby
class User
  include TheAuth::Model
end
```
