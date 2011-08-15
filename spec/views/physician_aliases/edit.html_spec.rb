require 'spec_helper'

describe "physician_aliases/edit.html" do

  before(:each) do
    assign(:physician, stub_model(Physician, :full_name => "$ *"))
    assign(:physician_alias, stub_model(PhysicianAlias).as_null_object)
    render
  end

  it { view.should render_template(:partial => "_form") }
end
