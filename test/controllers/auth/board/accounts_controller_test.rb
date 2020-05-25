require 'test_helper'

class Auth::Board::AccountsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @account = create :account
    post login_url, params: { identity: @account.identity, password: @account.user.password }
  end

  teardown do
    @account.destroy
  end

  test 'index ok' do
    get my_accounts_url
    assert_response :success
  end

  test 'create ok' do
    assert_difference('Account.count') do
      post my_accounts_url, params: { account: { identity: 'test1@work.design' } }, xhr: true
    end

    assert_response :success
  end

  test 'edit_confirm ok' do
    get confirm_my_account_url(@account)
    assert_response :success
  end

  test 'update ok' do
    patch my_account_url(@account), params: { account: { confirmed: true, primary: true } }
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('Account.count', -1) do
      delete my_account_url(@account), xhr: true
    end

    assert_response :success
  end
end
