require 'spec_helper'

describe "vacation_requests/index" do
  
  before(:each) do
    @mock_section = assign(:section, mock_model(Section))
    @mock_request = mock_model(VacationRequest, :created_at => DateTime.now,
      :start_date => Date.today, :end_date => Date.tomorrow,
      :status => VacationRequest::STATUS_PENDING, :comments => "Foo, bar!")
    @mock_request.stub_chain("requester.short_name") { "E. Fudd" }
    assign(:vacation_requests, [@mock_request])
    should_render_partial("schedules/section_menu")
    view.stub!(:can?)
    render
  end

  subject { rendered }

  it {
    should have_selector("a",
      :href => new_section_vacation_request_path(@mock_section),
      :content => "New Request"
    )
  }

  it { should have_selector("table tr td", :content => @mock_request.requester.short_name) }

  it { should have_selector("table tr td", :content => @mock_request.status.capitalize) }

  it { should have_selector("table tr td", :content => @mock_request.comments) }
end
