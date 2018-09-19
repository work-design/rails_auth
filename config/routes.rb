Rails.application.routes.draw do

  scope module: :rails_auth_web, controller: :join do
    get 'join', action: 'new'
    post 'join', action: 'create'
    get 'mobile' => :new_mobile
    post 'mobile' => :create_mobile
    get :mobile_confirm
  end

  scope module: :rails_auth_web, controller: :login do
    get 'login', action: 'new'
    post 'login', action: 'create'
    get 'logout', action: 'destroy'
  end

  scope :password, module: :rails_auth_web, controller: :password do
    get 'forget', action: 'new', as: 'password_forget'
    post 'forget', action: 'create'
    get 'reset/:token', action: 'edit', as: 'password_reset'
    post 'reset/:token', action: 'update'
  end

  scope :confirm, module: :rails_auth_web, controller: :confirm do
    post 'email', action: 'email'
    post 'mobile', action: 'mobile'
    post 'confirm/:token', action: 'update'
  end

  scope :admin, module: 'rails_auth_admin', as: 'admin' do
    resources :users
    resources :oauth_users
  end

  scope :my, module: 'rails_auth_my', as: 'my' do
    resource :user
    resources :oauth_users
  end

end

RailsAuth::Engine.routes.draw do

  scope '', module: 'rails_auth_api' do
    resource :me
    controller :login do
      post 'login', action: 'create'
    end
    controller :join do
      get 'join', action: 'new_verify'
      post 'join', action: 'create_verify'
    end
    resources :oauth_users, only: [:create]
  end

end