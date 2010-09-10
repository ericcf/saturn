require 'spec_helper'

describe "vacation_requests/_form" do

  before(:each) do
    @mock_section = assign(:section, stub_model(Section))
    @mock_vacation_request = assign(:vacation_request, stub_model(VacationRequest))
    render
  end

  it "renders a form for creating a vacation request" do
    rendered.should have_selector("form",
      :action => section_vacation_request_path(@mock_section, @mock_vacation_request),
      :method => "post"
    ) do |form|
      form.should have_selector("input", :type => "submit")
    end
  end

  it "renders a field for comments" do
    rendered.should have_selector("form textarea",
      :name => "vacation_request[comments]"
    )
  end
end