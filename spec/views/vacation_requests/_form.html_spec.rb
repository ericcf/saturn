require 'spec_helper'

describe "vacation_requests/_form.html" do

  let(:mock_section) { stub_model(Section) }
  let(:mock_vacation_request) { stub_model(VacationRequest) }

  before(:each) do
    assign(:section, mock_section)
    assign(:vacation_request, mock_vacation_request)
    should_render_partial("schedules/section_menu.html")
    render
  end

  subject { rendered }

  it "renders a form for creating a vacation request" do
    should have_selector("form",
      :action => section_vacation_request_path(mock_section, mock_vacation_request),
      :method => "post"
    ) do |form|
      form.should have_selector("input", :type => "submit")
    end
  end

  it "renders a field for comments" do
    should have_selector("form textarea",
      :name => "vacation_request[comments]"
    )
  end
end