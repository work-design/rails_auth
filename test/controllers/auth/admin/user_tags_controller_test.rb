require 'test_helper'

class Auth::Admin::UserTagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @auth_admin_user_tag = create auth_admin_user_tags
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
      post admin_user_tags_url, params: { #{singular_table_name}: { #{attributes_string} } }
    end

    assert_redirected_to auth_admin_user_tag_url(UserTag.last)
  end

  test 'show ok' do
    get admin_user_tag_url(@auth_admin_user_tag)
    assert_response :success
  end

  test 'edit ok' do
    get edit_admin_user_tag_url(@auth_admin_user_tag)
    assert_response :success
  end

  test 'update ok' do
    patch admin_user_tag_url(@auth_admin_user_tag), params: { #{singular_table_name}: { #{attributes_string} } }
    assert_redirected_to auth_admin_user_tag_url(@#{singular_table_name})
  end

  test 'destroy ok' do
    assert_difference('UserTag.count', -1) do
      delete admin_user_tag_url(@auth_admin_user_tag)
    end

    assert_redirected_to admin_user_tags_url
  end
end
