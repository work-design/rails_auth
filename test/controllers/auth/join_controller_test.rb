require 'test_helper'

class Auth::JoinControllerTest < ActionDispatch::IntegrationTest

  setup do
    ApplicationController.include RailsAuthController
    User.include RailsAuthUser
  end

  test 'new ok' do
    get join_url
    assert_response :success
  end

  test 'create ok' do
    create :email_token, account: 'mingyuan0715@foxmail.com', token: '111111'
    assert_difference('User.count') do
      post join_url, params: { user: { account: 'mingyuan0715@foxmail.com', password: '111111' }, token: '111111' }
    end
  end

end
