require 'test_helper'

class Auth::Panel::AccountsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @account = create :account
  end

  test 'index ok' do
    get panel_accounts_url
    assert_response :success
  end

  test 'new ok' do
    get new_panel_account_url, xhr: true
    assert_response :success
  end

  test 'create ok' do
    Account.delete_all

    assert_difference('Account.count') do
      post panel_accounts_url, params: { account: { identity: 'test@work.design' } }, xhr: true
    end

    assert_response :success
  end

  test 'show ok' do
    get panel_account_url(@account), xhr: true
    assert_response :success
  end

  test 'edit ok' do
    get edit_panel_account_url(@account), xhr: true
    assert_response :success
  end

  test 'update ok' do
    patch panel_account_url(@account), params: { identity: 'test_update@work.design' }, xhr: true
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('Account.count', -1) do
      delete panel_account_url(@account), xhr: true
    end

    assert_response :success
  end

end
