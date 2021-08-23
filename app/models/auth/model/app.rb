module Auth
  module Model::App
    extend ActiveSupport::Concern

    included do
      attribute :appid, :string, index: true
      attribute :jwt_key, :string
    end


  end
end
