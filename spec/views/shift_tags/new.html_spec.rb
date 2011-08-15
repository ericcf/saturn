require 'spec_helper'

describe "shift_tags/new.html" do

  it "renders the form partial" do
    assign(:section, stub_model(Section))
    assign(:shift_tag, stub_model(ShiftTag).as_new_record)
    render
    should render_template(:partial => "_form")
  end
end
