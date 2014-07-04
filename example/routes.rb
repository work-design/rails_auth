TheAuth::Engine.routes.draw do

  get 'signup' => 'users#new', :as => :signup
  get 'login' => 'user_sessions#new', :as => :login
  delete 'logout' => 'user_sessions#destroy', :as => :logout
  resource :user
  resource :user_session, :only => [:create]
  resource :password

end
