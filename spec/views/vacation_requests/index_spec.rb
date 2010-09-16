require 'spec_helper'

describe "vacation_requests/index" do
  
  before(:each) do
    @mock_section = assign(:section, mock_model(Section))
    @mock_request = mock_model(VacationRequest)
    @mock_request.stub_chain(:requester, :short_name).and_return("E. Fudd")
    assign(:vacation_requests, [@mock_request])
    should_render_partial("schedules/section_menu")
    render
  end

  it "renders a link to add a new request" do
    rendered.should have_selector("a",
      :href => new_section_vacation_request_path(@mock_section),
      :content => "New Request"
    )
  end

  it "renders the list of requesters" do
    rendered.should have_selector("table tr td", :content => "E. Fudd")
  end
end
