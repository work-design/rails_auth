Rails.application.routes.draw do

  namespace 'auth', defaults: { business: 'auth' } do
    controller :sign do
      match :sign, via: [:get, :post]
      get :token
      get :code
      get :bind
      post :direct
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
    resources :users, only: [:index, :show]

    namespace :admin, defaults: { namespace: 'admin' } do
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

    namespace :panel, defaults: { namespace: 'panel' } do
      resources :users do
        get :panel, on: :collection
        member do
          post :mock
          get 'user_tags' => :edit_user_tags
          patch 'user_tags' => :update_user_tags
        end
      end
      resources :accounts do
        member do
          delete :prune
        end
      end
      resources :oauth_users
      resources :authorized_tokens
      resources :apps
    end

    namespace :my, defaults: { namespace: 'my' } do
      root 'home#index'
      resource :user
    end

    namespace :board, defaults: { namespace: 'board' } do
      resource :user
      resources :accounts do
        member do
          post :token
          post :confirm
          put :select
        end
      end
      resources :oauth_users do
        collection do
          get :bind
        end
      end
    end
  end

  scope :auth, module: 'auth', controller: :oauths, as: 'oauths' do
    match ':provider/callback' => :create, via: [:get, :post]
    match ':provider/failure' => :failure, via: [:get, :post]
  end

end
