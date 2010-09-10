require 'spec_helper'

describe "people/show" do

  def mock_person(stubs={})
    @mock_person ||= mock_model(Person, stubs)
  end

  before(:each) do
    assign(:person, mock_person(:full_name => "Pointy Hair"))
    render
  end

  it { rendered.should have_selector("h2", :content => mock_person.full_name) }
end
