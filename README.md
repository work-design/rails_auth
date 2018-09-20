# RailsAuth

`RailsAuth`是个处理鉴权的`Rails Engine`

## 特性

- [系列项目说明](https://github.com/yougexiangfa/yougexiangfa)
- 使用`Rails`自带的`ActiveModel::SecurePassword`模块处理密码;

## 文件说明


## 如何使用


```ruby
class ApplicationController < ActionController::Base
  include RailsAuthController
  before_action :require_login_from_session
end
```

#### Include in Model

```ruby
class User
  include RailsAuthUser
end
```

## The methods RailsAuth provided：

```ruby
# in controller
current_user
```

