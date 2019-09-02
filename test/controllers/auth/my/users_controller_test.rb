require 'test_helper'

class Auth::Mine::UsersControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = create :user
    post '/login', params: { account: @user.email, password: @user.password }
    follow_redirect!
  end

  test 'show ok' do
    get my_user_url
    assert_response :success
  end

  test 'edit ok' do
    get edit_my_user_url
    assert_response :success
  end

  test 'update ok' do
    patch my_user_url,
          params: { user: { name: 'a@b.c' } }
    @user.reload
    assert_equal 'a@b.c', @user.name
    assert_redirected_to my_user_url
  end

  test 'destroy ok' do
    assert_difference('User.count', -1) do
      delete my_user_url
    end

    assert_redirected_to my_user_url
  end
end
