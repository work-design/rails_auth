Rails.application.routes.draw do

  scope module: :auth do
    controller :sign do
      match :sign, via: [:get, :post]
      post 'sign/token' => :token
      post 'sign/mock' => :mock
      post :login
      get :logout
    end

    scope :password, controller: :password, as: 'password' do
      get 'forget' => :new
      post 'forget' => :create
      scope as: 'reset' do
        get 'reset/:token' => :edit
        post 'reset/:token' => :update
      end
    end

    scope :auth, controller: :oauths, as: 'oauths' do
      match ':provider/callback' => :create, via: [:get, :post]
      match ':provider/failure' => :failure, via: [:get, :post]
    end
    resources :users, only: [:index, :show]
  end

  scope :admin, module: 'auth/admin', as: :admin do
    resources :oauth_users
    resources :user_tags
  end

  scope :panel, module: 'auth/panel', as: :panel do
    resources :users do
      get :panel, on: :collection
      member do
        post :mock
        get 'user_tags' => :edit_user_tags
        patch 'user_tags' => :update_user_tags
      end
    end
    resources :accounts
    resources :authorized_tokens
  end

  scope :my, module: 'auth/mine', subdomain: /.+\.#{RailsOrg.config.subdomain}/, as: :my do
    resource :user
  end if defined? RailsOrg

  scope :my, module: 'auth/board', as: :my do
    resource :user
    resources :accounts do
      member do
        post :token
        post :confirm
      end
    end
    resources :oauth_users do
      collection do
        get :bind
      end
    end
  end

end
