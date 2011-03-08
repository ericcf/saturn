require 'spec_helper'

describe "call_shifts/new.html" do

  it "renders the form partial" do
    assign(:section, stub_model(Section))
    assign(:call_shift, stub_model(CallShift))
    should_render_partial("form")
    render
  end
end
