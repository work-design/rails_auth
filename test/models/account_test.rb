require 'test_helper'

class AccountTest < ActiveSupport::TestCase

  test 'clear_reset_token!' do
    account = create :account

    assert_kind_of String, account.auth_token
  end

end
