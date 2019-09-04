require 'test_helper'

class Auth::Mine::AccountsControllerTest < ActionDispatch::IntegrationTest
  
  setup do
    @auth_my_account = auth_my_accounts(:one)
  end

  test "should get index" do
    get my_accounts_url
    assert_response :success
  end

  test "should get new" do
    get new_my_account_url
    assert_response :success
  end

  test "should create auth_my_account" do
    assert_difference('Account.count') do
      post my_accounts_url, params: { auth_my_account: { account: @auth_my_account.account, confirmed: @auth_my_account.confirmed, primary: @auth_my_account.primary } }
    end

    assert_redirected_to auth_my_account_url(Account.last)
  end

  test "should show auth_my_account" do
    get my_account_url(@auth_my_account)
    assert_response :success
  end

  test "should get edit" do
    get edit_my_account_url(@auth_my_account)
    assert_response :success
  end

  test "should update auth_my_account" do
    patch my_account_url(@auth_my_account), params: { auth_my_account: { account: @auth_my_account.account, confirmed: @auth_my_account.confirmed, primary: @auth_my_account.primary } }
    assert_redirected_to auth_my_account_url(@auth_my_account)
  end

  test "should destroy auth_my_account" do
    assert_difference('Account.count', -1) do
      delete my_account_url(@auth_my_account)
    end

    assert_redirected_to my_accounts_url
  end
end
