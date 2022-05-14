module Auth
  class DisposableTokenCleanJob < ApplicationJob

    def perform(disposable_token)
      disposable_token.destroy
    end

  end
end
