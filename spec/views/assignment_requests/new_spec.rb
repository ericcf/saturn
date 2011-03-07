require 'spec_helper'

describe "assignment_requests/new" do

  it "renders the form partial" do
    assign(:section, mock_model(Section))
    assign(:assignment_request, stub_model(AssignmentRequest))
    should_render_partial("form")
    render
  end
end
