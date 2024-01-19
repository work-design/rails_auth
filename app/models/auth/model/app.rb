module Auth
  module Model::App
    extend ActiveSupport::Concern

    included do
      attribute :appid, :string, index: true
      attribute :key, :string

      after_initialize :init_key, if: :new_record?
    end

    def init_key
      self.key = SecureRandom.alphanumeric(32)
    end

  end
end
