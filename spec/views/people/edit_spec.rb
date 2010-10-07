require 'spec_helper'

describe "people/edit" do

  before(:each) do
    assign(:person, stub_model(Person).as_null_object)
    render
  end

  it { view.should render_template(:partial => "_form") }
end
