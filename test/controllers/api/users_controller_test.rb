require 'test_helper'

class Api::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @api_user = api_users(:one)
  end

  test "should get index" do
    get api_users_url, as: :json
    assert_response :success
  end

  test "should create api_user" do
    assert_difference('User.count') do
      post api_users_url, params: { api_user: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show api_user" do
    get api_user_url(@api_user), as: :json
    assert_response :success
  end

  test "should update api_user" do
    patch api_user_url(@api_user), params: { api_user: {  } }, as: :json
    assert_response 200
  end

  test "should destroy api_user" do
    assert_difference('User.count', -1) do
      delete api_user_url(@api_user), as: :json
    end

    assert_response 204
  end
end
