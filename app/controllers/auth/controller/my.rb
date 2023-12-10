# frozen_string_literal: true

module Auth
  module Controller::My
    extend ActiveSupport::Concern

    included do
      layout 'my'
    end

  end
end
