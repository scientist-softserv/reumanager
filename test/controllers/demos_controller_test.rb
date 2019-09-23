require 'test_helper'

class DemosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get demos_index_url
    assert_response :success
  end

end
