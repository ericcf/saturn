require 'spec_helper'

describe "shift_tags/show" do

  before(:each) do
    assign(:shift_tag, mock_model(ShiftTag, :title => "Clinical"))
    render
  end

  it { rendered.should have_selector("h2", :content => assigns(:shift_tag)) }
end
