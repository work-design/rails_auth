require 'test_helper'

class Auth::Admin::AuthorizedTokensControllerTest < ActionDispatch::IntegrationTest
  setup do
    @authorized_token = create :authorized_token
  end

  test 'index ok' do
    get admin_authorized_tokens_url
    assert_response :success
  end

  test 'edit ok' do
    get edit_admin_authorized_token_url(@authorized_token), xhr: true
    assert_response :success
  end

  test 'update ok' do
    patch admin_authorized_token_url(@authorized_token), params: { authorized_token: { expire_at: Time.now } }, xhr: true
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('AuthorizedToken.count', -1) do
      delete admin_authorized_token_url(@authorized_token), xhr: true
    end

    assert_response :success
  end

end
