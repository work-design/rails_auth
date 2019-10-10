require 'test_helper'

class Auth::JoinControllerTest < ActionDispatch::IntegrationTest

  setup do
  end

  test 'sign ok' do
    get sign_url
    assert_response :success
  end
  
  test 'post sign ok' do
    post sign_url, params: { identity: 'test@work.design' }
    assert_response :success
  end

  test 'create ok' do
    create :email_token, account: 'mingyuan0715@foxmail.com', token: '111111'
    assert_difference('User.count') do
      post join_url, params: { identity: 'mingyuan0715@foxmail.com', password: '111111', token: '111111' }
    end
  end
  
  test 'logout ok' do
  
  end

end
