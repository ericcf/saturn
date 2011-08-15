require 'spec_helper'

describe "call_shifts/edit.html" do

  it "renders the form partial" do
    assign(:section, stub_model(Section))
    assign(:call_shift, stub_model(CallShift))
    render
    rendered.should render_template(:partial => "_form")
  end
end
