require 'spec_helper'

describe "meeting_requests/_form.html" do

  before(:each) do
    @mock_section = assign(:section, stub_model(Section))
    @mock_meeting_request = assign(:meeting_request, stub_model(MeetingRequest))
    should_render_partial("schedules/section_menu")
    render
  end

  it "renders a form for creating a vacation request" do
    rendered.should have_selector("form",
      :action => section_meeting_request_path(@mock_section, @mock_meeting_request),
      :method => "post"
    ) do |form|
      form.should have_selector("input", :type => "submit")
    end
  end

  it "renders a field for comments" do
    rendered.should have_selector("form textarea",
      :name => "meeting_request[comments]"
    )
  end
end
