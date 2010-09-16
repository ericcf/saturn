require 'spec_helper'

describe "vacation_requests/new" do

  it "renders the form partial" do
    assign(:section, mock_model(Section))
    assign(:vacation_request, stub_model(VacationRequest))
    should_render_partial("form")
    render
  end
end
