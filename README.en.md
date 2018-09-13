
# TheAuth

TheAuth is a Rails Engine for user authentification, more easy to use, more easy to override.


## Description

There are so many gems about auth, I seprated the engine from our projects because of:

- more easy to understand and use, for example, `devise` is good, but difficult to override and config, it's unfriendly to fresh developers;

- more easy to config, just normal rails contorller model and views; 

- used `ActiveModel::SecurePassword` which default included by rails, make so easy to do Password;

## How To Use

#### Config TheAuth

add this under `config/initializers`

```ruby
TheAuth.configure do |config|
end
```

#### Overwrite Routes

add the in the file: `config/routes.rb`

```ruby

```

#### include in Controller



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
