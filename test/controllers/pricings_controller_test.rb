require 'test_helper'

class PricingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pricings_index_url
    assert_response :success
  end

end
