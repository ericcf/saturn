require 'spec_helper'

describe "sections/edit.html" do

  before(:each) do
    assign(:section, stub_model(Section))
    render
  end

  it { view.should render_template(:partial => "_form") }
end
