require 'test_helper'

class Auth::Board::UsersControllerTest < ActionDispatch::IntegrationTest

  setup do
    @account = create :account
    @user = @account.user

    post '/login', params: { identity: @account.identity, password: @user.password }
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
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('User.count', -1) do
      delete my_user_url
    end

    assert_response :success
  end
end
