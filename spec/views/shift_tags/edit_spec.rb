require 'spec_helper'

describe "shift_tags/edit" do

  it "renders the form partial" do
    assign(:section, stub_model(Section))
    assign(:shift_tag, stub_model(ShiftTag))
    render
    view.should render_template(:partial => "_form")
  end
end
