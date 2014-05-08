Rails.application.routes.draw do

  mount TheAuth::Engine => "/auth"
end
