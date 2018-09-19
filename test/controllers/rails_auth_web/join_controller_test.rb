require 'test_helper'

class RailsAuthWeb::JoinControllerTest < ActionDispatch::IntegrationTest

  setup do
    ApplicationController.include RailsAuthController
    User.include RailsAuthUser
  end

  test 'new' do
    get join_url
    assert_response :success
  end

  test 'create' do
    assert_difference('User.count') do
      post join_url, params: { user: { email: 'mingyuan0715@foxmail.com', password: '111111' } }
    end
  end

end
