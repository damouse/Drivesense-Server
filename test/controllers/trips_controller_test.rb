require 'test_helper'

class TripsControllerTest < ActionController::TestCase
  test "should get all_trips" do
    get :all_trips
    assert_response :success
  end

  test "should get trip_viewer" do
    get :trip_viewer
    assert_response :success
  end

end
