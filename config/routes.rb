Rails.application.routes.draw do

  scope module: :the_auth, controller: :join do
    get 'join', action: 'new'
    post 'join', action: 'create'
  end

  scope module: :the_auth, controller: :login do
    get 'login', action: 'new'
    post 'login', action: 'create'
    get 'logout', action: 'logout'
  end

  scope module: :the_auth, controller: :password, path: :password do
    get 'reset', action: 'reset'
    post 'reset', action: 'send_reset'
    get 'confirm', action: 'confirm'
  end

  scope module: :the_auth, controller: :confirmation, path: :confirmation do
    post 'sent/:login', action: 'sent'
    get 'confirm/:login', action: 'confirm'
  end

end
