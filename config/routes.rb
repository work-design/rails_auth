Rails.application.routes.draw do
  scope RailsCom.default_routes_scope do
    draw :auth
  end
end
