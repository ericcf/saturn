require 'spec_helper'

describe "assignment_requests/edit" do

  it "renders the form partial" do
    assign(:section, mock_model(Section).as_null_object)
    assign(:assignment_request, stub_model(AssignmentRequest))
    render
    view.should render_template(:partial => "_form")
  end
end
