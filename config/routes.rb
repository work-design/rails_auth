Rails.application.routes.draw do
  scope RailsCom.default_routes_scope do
    namespace 'auth', defaults: { business: 'auth' } do
      controller :sign do
        match :sign, via: [:get, :post]
        post :code
        get :bind
        post :direct
        post :join
        get 'login' => :login_new
        post :login
        post :token_login
        post :token
        match :logout, via: [:get, :post]
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
        root 'home#index'
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
        root 'home#index'
        controller :home do
          get :dashboard
        end
        resources :users do
          collection do
            get :month
          end
          member do
            post :mock
            match :edit_user_tags, via: [:get, :post]
            patch 'user_tags' => :update_user_tags
            match :edit_role, via: [:get, :post]
          end
        end
        resources :accounts do
          member do
            delete :prune
          end
        end
        resources :verify_tokens
        resources :oauth_users do
          collection do
            get :month
          end
        end
        resources :authorized_tokens
        resources :apps
      end

      namespace :our, defaults: { namespace: 'our' } do
        root 'home#index'
      end

      namespace :board, defaults: { namespace: 'board' } do
        root 'home#index'
        resource :user do
          get :avatar
        end
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
end
