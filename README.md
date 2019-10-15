# RailsAuth

`RailsAuth`是个处理鉴权的`Rails Engine`

## 特性

* [系列项目说明](https://github.com/work-design/work-design)
* 使用`Rails`自带的`ActiveModel::SecurePassword`模块处理密码;
* 使用`auth token`统一鉴权，兼容api和cookies, 服务端可控制auth_token失效；
* 精致的架构:
  - 为合并用户提供了非常灵活的架构基础。
  - 支持多终端登陆。 
* 由于整个系统采用了唯一User的设计思路，通过`UserTag`为部分场景自动打标签；

## 文件说明
如果用户表和项目的表分离存贮，一定要注意不要在项目里使用`users`, `accounts`,  `oauth_users`任何一张表作为连表查询的中间表。

## 如何使用

* AccessToken 授权token
* VerifyToken 验证Token

```ruby
class ApplicationController < ActionController::Base
  include RailsAuth::Controller
  before_action :require_login
end
```

#### Include in Model

```ruby
class User < ActiveRecord::Base
  include RailsAuth::User
end
```

## The methods RailsAuth provided：

```ruby
# in controller
current_user
```

## License
The gem is available as open source under the terms of the [LGPL-3.0](https://opensource.org/licenses/LGPL-3.0).
