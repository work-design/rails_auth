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
    create :account
    post login_url, params: { identity: 'test@work.design', password: '111111' }
    assert_response 302
  end
  
  test 'logout ok' do
  
  end

end
