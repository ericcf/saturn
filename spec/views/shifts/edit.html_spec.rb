require 'spec_helper'

describe "shifts/edit.html" do

  it "renders the form partial" do
    assign(:section, stub_model(Section))
    assign(:shift, stub_model(Shift))
    should_render_partial("form.html")
    render
  end
end
