require 'spec_helper'

describe "meeting_requests/index.html" do

  let(:mock_section) { mock_model(Section) }
  let(:mock_request) do
    mock_model(MeetingRequest,
      :created_at => DateTime.now,
      :start_date => Date.today,
      :end_date => Date.tomorrow,
      :status => MeetingRequest::STATUS_PENDING,
      :comments => "Foo, bar!"
    )
  end
  
  before(:each) do
    assign(:section, mock_section)
    mock_request.stub_chain("requester.short_name") { "E. Fudd" }
    assign(:meeting_requests, [mock_request])
    should_render_partial("schedules/section_menu")
    view.stub!(:can?)
    render
  end

  subject { rendered }

  it {
    should have_selector("a",
      :href => new_section_meeting_request_path(mock_section),
      :content => "New Request"
    )
  }

  it { should have_selector("table tr td", :content => mock_request.requester.short_name) }

  it { should have_selector("table tr td", :content => mock_request.status.capitalize) }

  it { should have_selector("table tr td", :content => mock_request.comments) }
end
