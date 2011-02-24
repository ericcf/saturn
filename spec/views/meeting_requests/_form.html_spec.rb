require 'spec_helper'

describe "meeting_requests/_form.html" do

  let(:mock_section) { stub_model(Section) }
  let(:mock_request) { stub_model(MeetingRequest) }

  before(:each) do
    assign(:section, mock_section)
    assign(:meeting_request, mock_request)
    should_render_partial("schedules/section_menu")
    render
  end

  subject { rendered }

  it "renders a form for creating a vacation request" do
    should have_selector("form",
      :action => section_meeting_request_path(mock_section, mock_request),
      :method => "post"
    ) do |form|
      form.should have_selector("input", :type => "submit")
    end
  end

  it "renders a field for comments" do
    should have_selector("form textarea",
      :name => "meeting_request[comments]"
    )
  end
end
