require 'test_helper'

class Auth::Mine::AccountsControllerTest < ActionDispatch::IntegrationTest
  
  setup do
    @account = create :account
    post login_url, params: { identity: @account.identity, password: @account.user.password }
    follow_redirect!
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
      post my_accounts_url, params: { account: { identity: 'test1@work.design' } }
    end

    assert_response :success
  end

  test 'update ok' do
    patch my_account_url(@account), params: { account: { identity: 'test1@work.design', confirmed: true, primary: true } }
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('Account.count', -1) do
      delete my_account_url(@account)
    end

    assert_response :success
  end
end
