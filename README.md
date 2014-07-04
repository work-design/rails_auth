
`the_auth`是更容易理解的鉴权功能，基于`rails engine` 和 `warden`创建。

## 使用说明

#### 配置`the_auth`

```ruby
TheAuth.configure do |config|
  config.layout                = :home
  config.default_user_class    = 'StatsUser'
  config.access_denied_method  = :access_denied      # define it in ApplicationController
  config.login_required_method = :authenticate_user! # devise auth method
end
```

#### 配置`warden`

```ruby
参考 example 文件夹下地代码示例
```

#### 集成到controller

在 Application controller 中`include TheRoleController`

```ruby
class ApplicationController < ActionController::Base
  include TheAuth::Controller

  protect_from_forgery with: :exception

  helper_method :current_user

end
```



