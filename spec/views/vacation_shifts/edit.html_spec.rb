require 'spec_helper'

describe "vacation_shifts/edit.html" do

  it "renders the form partial" do
    assign(:section, stub_model(Section))
    assign(:vacation_shift, stub_model(VacationShift))
    should_render_partial("form")
    render
  end
end
