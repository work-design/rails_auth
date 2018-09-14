
# TheAuth

`TheAuth`是个处理鉴权的`Rails Engine`

## 特性

- [系列项目说明](https://github.com/yougexiangfa/yougexiangfa)
- 使用`Rails`自带的`ActiveModel::SecurePassword`模块处理密码;

## 文件说明


## 如何使用


### 



```ruby
class ApplicationController < ActionController::Base
  include TheAuthController
end
```

#### Include in Model

```ruby
class User
  include TheAuthUser
end
```

## The methods TheAuth provided：

```ruby
# in controller
current_user
```
