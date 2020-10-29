Rails.application.routes.draw do

  scope module: 'auth', defaults: { business: 'auth' } do
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

  scope :admin, module: 'auth/admin', as: :admin, defaults: { namespace: 'admin', business: 'auth' } do
    resources :oauth_users
    resources :user_tags do
      resources :user_taggeds do
        collection do
          delete '' => :destroy
          get :search
        end
      end
    end
  end

  scope :panel, module: 'auth/panel', as: :panel, defaults: { namespace: 'panel', business: 'auth' } do
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

  scope :my, module: 'auth/my', as: :my, defaults: { namespace: 'my', business: 'auth' } do
    resource :user
  end

  scope :board, module: 'auth/board', as: :board, defaults: { namespace: 'board', business: 'auth' } do
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
