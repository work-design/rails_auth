require 'test_helper'

class TheAuth::JoinControllerTest < ActionDispatch::IntegrationTest

  setup do
    ApplicationController.include TheAuthController
    #binding.pry
    #@user = create :user
  end

  test 'new' do
    get join_url
    assert_response :success
  end

  test 'create' do
    assert_difference('User.count') do
      post join_url, params: { user: { login: 'mingyuan0715@foxmail.com', password: '111' } }
    end
  end

end
