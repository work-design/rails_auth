Rails.application.routes.draw do

  get 'signup' => 'users#new', as: :signup
  get 'login' => 'user_sessions#new', as: :login
  match 'logout' => 'user_sessions#destroy', as: :logout, via: [:delete, :get]
  resource :user
  resource :user_session, only: [:create]
  resource :password

end
