require 'spec_helper'

describe "meeting_shifts/edit.html" do

  it "renders the form partial" do
    assign(:section, stub_model(Section))
    assign(:meeting_shift, stub_model(MeetingShift))
    should_render_partial("form")
    render
  end
end
