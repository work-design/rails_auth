Auth::Engine.routes.draw do

  resource :user
  resource :user_session, :only => [:new, :create, :destroy]
  resource :password

end
