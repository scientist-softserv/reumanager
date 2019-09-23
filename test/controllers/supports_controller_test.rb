require 'test_helper'

class SupportsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get supports_index_url
    assert_response :success
  end

end
