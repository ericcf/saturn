require 'spec_helper'

describe "meeting_requests/new.html" do

  it "renders the form partial" do
    assign(:section, mock_model(Section))
    assign(:meeting_request, stub_model(MeetingRequest))
    should_render_partial("form")
    render
  end
end
