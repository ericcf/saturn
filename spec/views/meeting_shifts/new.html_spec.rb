require 'spec_helper'

describe "meeting_shifts/new.html" do

  it "renders the form partial" do
    assign(:section, stub_model(Section))
    assign(:meeting_shift, stub_model(MeetingShift))
    render
    should render_template(:partial => "_form")
  end
end
