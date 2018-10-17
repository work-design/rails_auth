Rails.application.routes.draw do

  scope module: :auth do
    controller :join do
      get 'join' => :new
      post 'join' => :create
    end

    scope :join, controller: 'mobile', as: 'join' do
      get 'mobile' => :new
      post 'mobile' => :create
      get :confirm
    end

    controller :login do
      get 'login' => :new
      post 'login' => :create
      get 'logout' => :destroy
    end

    scope :password, controller: :password, as: 'password' do
      get 'forget' => :new
      post 'forget' => :create
      scope as: 'reset' do
        get 'reset/:token' => :edit
        post 'reset/:token' => :update
      end
    end

    controller :confirm do
      post 'email' => :email
      post 'mobile' => :mobile
      post 'confirm/:token' => :update
    end
  end

  scope :admin, module: 'auth/admin', as: 'admin' do
    resources :users
    resources :oauth_users
  end

  scope :my, module: 'auth/my', as: 'my' do
    resource :user
    resources :oauth_users
  end

end

RailsAuth::Engine.routes.draw do

  scope module: 'auth/api', as: 'api' do
    resource :me
    controller :login do
      post 'login' => :create
    end
    controller :join do
      get 'join' => :new_verify
      post 'join' => :create_verify
    end
    resources :oauth_users, only: [:create]
  end

end
