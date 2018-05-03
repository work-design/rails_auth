Rails.application.routes.draw do

  scope module: :the_auth_web, controller: :join do
    get 'join', action: 'new'
    post 'join', action: 'create'
    get 'mobile' => :new_mobile
    post 'mobile' => :create_mobile
    get :mobile_confirm
  end

  scope module: :the_auth_web, controller: :login do
    get 'login', action: 'new'
    post 'login', action: 'create'
    get 'logout', action: 'destroy'
  end

  scope module: :the_auth_web, controller: :password, path: :password do
    get 'forget', action: 'new', as: 'password_forget'
    post 'forget', action: 'create'
    get 'reset/:token', action: 'edit', as: 'password_reset'
    post 'reset/:token', action: 'update'
  end

  scope module: :the_auth_web, controller: :confirm, path: :confirm do
    post 'email', action: 'email'
    post 'mobile', action: 'mobile'
    post 'confirm/:token', action: 'update'
  end

  scope :admin, module: :the_auth_admin, as: :admin do
    resources :users do
      patch :toggle, on: :member
    end
    resources :oauth_users
  end

  scope module: 'the_auth_api', path: 'api' do
    resource :me
    controller :login do
      post 'login', action: 'create'
    end
    resources :oauth_users, only: [:create]
  end

end
