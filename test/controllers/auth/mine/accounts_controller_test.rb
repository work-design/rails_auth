require 'test_helper'

class Auth::Mine::AccountsControllerTest < ActionDispatch::IntegrationTest
  
  setup do
    user = create :user
    post login_url, params: { identity: user.email, password: user.password }
    follow_redirect!
    
    @account = create :account
  end

  test 'index ok' do
    get my_accounts_url
    assert_response :success
  end

  test 'new ok' do
    get new_my_account_url
    assert_response :success
  end

  test "should create auth_my_account" do
    assert_difference('Account.count') do
      post my_accounts_url, params: { auth_my_account: { account: @account.account, confirmed: @account.confirmed, primary: @account.primary } }
    end

    assert_response :success
  end

  test "should show auth_my_account" do
    get my_account_url(@account)
    assert_response :success
  end

  test "should get edit" do
    get edit_my_account_url(@account)
    assert_response :success
  end

  test "should update auth_my_account" do
    patch my_account_url(@account), params: { auth_my_account: { account: @account.account, confirmed: @account.confirmed, primary: @account.primary } }
    assert_response :success
  end

  test "should destroy auth_my_account" do
    assert_difference('Account.count', -1) do
      delete my_account_url(@account)
    end

    assert_response :success
  end
end
