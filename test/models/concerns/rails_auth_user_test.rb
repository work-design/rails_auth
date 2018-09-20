require 'test_helper'

class RailsAuthUserTest < ActiveSupport::TestCase

  test 'clear_reset_token!' do
    user = create :user

    assert_kind_of String, user.reset_token.token
  end

end
