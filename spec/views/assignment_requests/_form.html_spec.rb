require 'spec_helper'

describe "assignment_requests/_form.html" do

  let(:mock_section) do
    mock_model(Section, :members => [], :active_shifts => [])
  end
  let(:mock_assignment_request) do
    mock_model(AssignmentRequest, :requester_id => nil, :shift_id => nil, :start_date => nil, :end_date => nil, :comments => nil)
  end

  before(:each) do
    render "assignment_requests/form",
      :assignment_request => mock_assignment_request, :section => mock_section
  end

  subject { rendered }

  it "renders a form for creating a assignment request" do
    should have_selector("form",
      :action => section_assignment_request_path(mock_section, mock_assignment_request),
      :method => "post"
    ) do |form|
      form.should have_selector("input", :type => "submit")
    end
  end

  it "renders a select list for the requester" do
    should have_selector("form select",
      :name => "assignment_request[requester_id]"
    )
  end

  it "renders a select list for the shift" do
    should have_selector("form select",
      :name => "assignment_request[shift_id]"
    )
  end

  it "renders a field for the start date" do
    should have_selector("form input",
      :name => "assignment_request[start_date]"
    )
  end

  it "renders a field for the end date" do
    should have_selector("form input",
      :name => "assignment_request[end_date]"
    )
  end

  it "renders a field for comments" do
    should have_selector("form input",
      :name => "assignment_request[comments]"
    )
  end
end
