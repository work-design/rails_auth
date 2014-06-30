module TheAuth
  class ApplicationController < ::ApplicationController
    layout  TheAuth.config.layout.to_s
    include TheAuth::Controller

  end
end
