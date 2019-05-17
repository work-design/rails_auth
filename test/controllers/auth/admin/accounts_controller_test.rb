require 'test_helper'

class Auth::Admin::AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account = create :account
  end

  test 'index ok' do
    get admin_accounts_url
    assert_response :success
  end

  test 'new ok' do
    get new_admin_account_url
    assert_response :success
  end

  test 'create ok' do
    assert_difference('Account.count') do
      post admin_accounts_url, params: {  }
    end

    assert_redirected_to auth_admin_account_url(Account.last)
  end

  test 'show ok' do
    get admin_account_url(@account)
    assert_response :success
  end

  test 'edit ok' do
    get edit_admin_account_url(@account)
    assert_response :success
  end

  test 'update ok' do
    patch admin_account_url(@account), params: {  }
    assert_redirected_to auth_admin_account_url(@account)
  end

  test 'destroy ok' do
    assert_difference('Account.count', -1) do
      delete admin_account_url(@account)
    end

    assert_redirected_to admin_accounts_url
  end
end
