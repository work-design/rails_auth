require 'test_helper'
class Auth::Mine::OauthUsersControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = create :user
    post '/login', params: { identity: @user.email, password: @user.password }
    follow_redirect!
    @oauth_user = create :oauth_user
  end

  test 'index ok' do
    get my_oauth_users_url
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('OauthUser.count', -1) do
      delete my_oauth_user_url(@oauth_user)
    end

    assert_redirected_to my_oauth_users_url
  end
end
