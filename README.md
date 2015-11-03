
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
  config.layout = :application  # the_auth view 的layout
end
```

#### Config Routes

add the in the file: `config/routes.rb`

```ruby
scope module: :the_auth do
  get 'signup' => 'users#new', as: :signup  
  get 'login' => 'user_sessions#new', as: :login  
  delete 'logout' => 'user_sessions#destroy', as: :logout
  resource :user
  resource :user_session, :only => [:create]
  resource :password
end
```

#### include in Controller



```ruby
class ApplicationController < ActionController::Base
  include TheAuth::Controller
end
```

#### Include in Model

```ruby
class User
  include TheAuth::Model
end
```

## The methods TheAuth provided：

```ruby
# in controller
current_user
```
