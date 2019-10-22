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
    get new_admin_account_url, xhr: true
    assert_response :success
  end

  test 'create ok' do
    Account.delete_all
    
    assert_difference('Account.count') do
      post admin_accounts_url, params: { account: { identity: 'test@work.design' } }, xhr: true
    end

    assert_response :success
  end

  test 'show ok' do
    get admin_account_url(@account), xhr: true
    assert_response :success
  end

  test 'edit ok' do
    get edit_admin_account_url(@account), xhr: true
    assert_response :success
  end

  test 'update ok' do
    patch admin_account_url(@account), params: { identity: 'test_update@work.design' }, xhr: true
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('Account.count', -1) do
      delete admin_account_url(@account), xhr: true
    end

    assert_response :success
  end

end
