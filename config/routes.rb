Rails.application.routes.draw do

  scope module: :the_auth, controller: :join do
    get 'join', action: 'new'
    post 'join', action: 'create'
  end

  scope module: :the_auth, controller: :login do
    get 'login', action: 'new'
    post 'login', action: 'create'
    get 'logout', action: 'destroy'
  end

  scope module: :the_auth, controller: :password, path: :password do
    get 'reset', action: 'reset'
    post 'reset', action: 'update_reset'
    get 'confirm/:token', action: 'confirm', as: 'password_confirm'
    post 'confirm', action: 'update_confirm', as: 'password_update_confirm'
  end

  scope module: :the_auth, controller: :confirm, path: :confirm do
    get 'email/:token', action: 'email', as: 'confirm'
    get 'new', action: 'new'
  end

end
