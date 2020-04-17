require 'test_helper'

class Auth::Panel::AuthorizedTokensControllerTest < ActionDispatch::IntegrationTest
  setup do
    @authorized_token = create :authorized_token
  end

  test 'index ok' do
    get panel_authorized_tokens_url
    assert_response :success
  end

  test 'edit ok' do
    get edit_panel_authorized_token_url(@authorized_token), xhr: true
    assert_response :success
  end

  test 'update ok' do
    patch panel_authorized_token_url(@authorized_token), params: { authorized_token: { expire_at: Time.now } }, xhr: true
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('AuthorizedToken.count', -1) do
      delete panel_authorized_token_url(@authorized_token), xhr: true
    end

    assert_response :success
  end

end
