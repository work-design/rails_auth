require 'test_helper'

class Auth::Admin::UserTagsControllerTest < ActionDispatch::IntegrationTest
  
  setup do
    @user_tag = create :user_tag
  end

  test 'index ok' do
    get admin_user_tags_url
    assert_response :success
  end

  test 'new ok' do
    get new_admin_user_tag_url
    assert_response :success
  end

  test 'create ok' do
    assert_difference('UserTag.count') do
      post admin_user_tags_url, params: { user_tag: { name: 'good' } }
    end

    assert_response :success
  end

  test 'show ok' do
    get admin_user_tag_url(@user_tag)
    assert_response :success
  end

  test 'edit ok' do
    get edit_admin_user_tag_url(@user_tag)
    assert_response :success
  end

  test 'update ok' do
    patch admin_user_tag_url(@user_tag), params: { user_tag: { name: 'good' } }
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('UserTag.count', -1) do
      delete admin_user_tag_url(@user_tag)
    end

    assert_response :success
  end
  
end
