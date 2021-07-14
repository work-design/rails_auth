require 'test_helper'
class Auth::Admin::UserTaggedsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @auth_admin_user_tagged = create auth_admin_user_taggeds
  end

  test 'index ok' do
    get admin_user_taggeds_url
    assert_response :success
  end

  test 'new ok' do
    get new_admin_user_tagged_url
    assert_response :success
  end

  test 'create ok' do
    assert_difference('UserTagged.count') do
      post admin_user_taggeds_url, params: { }
    end

    assert_response :success
  end

  test 'show ok' do
    get admin_user_tagged_url(@auth_admin_user_tagged)
    assert_response :success
  end

  test 'edit ok' do
    get edit_admin_user_tagged_url(@auth_admin_user_tagged)
    assert_response :success
  end

  test 'update ok' do
    patch admin_user_tagged_url(@auth_admin_user_tagged), params: { }
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('UserTagged.count', -1) do
      delete admin_user_tagged_url(@auth_admin_user_tagged)
    end

    assert_response :success
  end

end
