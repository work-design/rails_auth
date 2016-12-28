require 'test_helper'

class TestssesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @testss = testsses(:one)
  end

  test "should get index" do
    get testsses_url
    assert_response :success
  end

  test "should get new" do
    get new_testss_url
    assert_response :success
  end

  test "should create testss" do
    assert_difference('Testss.count') do
      post testsses_url, params: { testss: {  } }
    end

    assert_redirected_to testss_url(Testss.last)
  end

  test "should show testss" do
    get testss_url(@testss)
    assert_response :success
  end

  test "should get edit" do
    get edit_testss_url(@testss)
    assert_response :success
  end

  test "should update testss" do
    patch testss_url(@testss), params: { testss: {  } }
    assert_redirected_to testss_url(@testss)
  end

  test "should destroy testss" do
    assert_difference('Testss.count', -1) do
      delete testss_url(@testss)
    end

    assert_redirected_to testsses_url
  end
end
