require 'rails_auth/version'
require 'rails_auth/engine'
require 'rails_auth/config'

module Auth

  def self.use_relative_model_naming?
    true
  end

end
