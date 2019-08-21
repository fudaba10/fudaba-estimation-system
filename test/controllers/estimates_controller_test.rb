require 'test_helper'

class EstimatesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get estimates_index_url
    assert_response :success
  end

  test "should get new" do
    get estimates_new_url
    assert_response :success
  end

  test "should get show" do
    get estimates_show_url
    assert_response :success
  end

  test "should get edit" do
    get estimates_edit_url
    assert_response :success
  end

end
