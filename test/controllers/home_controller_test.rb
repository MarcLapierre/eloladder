require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "#index is accessible" do
    get home_index_url
    assert_response :success
  end

  test "#plans is accessible" do
    get home_plans_url
    assert_response :success
  end
end
