require 'spec_helper'

describe ConferencesController do

  def mock_conference(stubs={})
    (@mock_conference ||= stub_model(Conference).as_null_object).tap do |conference|
      conference.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do

    it "assigns conferences as @conferences" do
      Conference.stub_chain(:occur_on, :order) { [mock_conference] }
      get :index
      assigns(:conferences).should eq([mock_conference])
    end

    context "no date specified" do

      it "assigns today as @date" do
        today = Date.today
        Date.stub(:today) { today }
        get :index
        assigns(:date).should eq(today)
      end
    end
  end

  describe "GET show" do
    it "assigns the requested conference as @conference" do
      Conference.stub(:find).with("37") { mock_conference }
      get :show, :id => "37"
      assigns(:conference).should be(mock_conference)
    end
  end
end
