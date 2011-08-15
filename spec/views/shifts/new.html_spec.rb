require 'spec_helper'

describe "shifts/new.html" do

  it "renders the form partial" do
    assign(:section, stub_model(Section))
    assign(:shift, stub_model(Shift))
    render
    should render_template(:partial => "_form")
  end
end
