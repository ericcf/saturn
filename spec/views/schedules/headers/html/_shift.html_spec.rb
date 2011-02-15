require 'spec_helper'

describe "schedules/headers/html/_shift.html" do

  context "there is an associated number" do

    before(:each) do
      mock_shift = stub_model(Shift, :phone => "12345")
      render :partial => "schedules/headers/html/shift.html",
        :locals => { :shift => mock_shift }
    end

    subject { rendered }

    it { should have_selector("img", :src => image_path("phone.jpg")) }
  end
end
