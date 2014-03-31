require 'spec_helper'

describe TripsCoordinatesController do

  describe "GET 'new_trip'" do
    it "returns http success" do
      get 'new_trip'
      expect(response).to be_success
    end
  end

end
