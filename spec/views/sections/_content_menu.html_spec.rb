require 'spec_helper'

describe "sections/_content_menu.html" do

  let(:mock_section) { stub_model(Section, :title => "Foo") }

  before(:each) do
    view.stub!(:cannot?)
    assign(:section, mock_section)
    render
  end

  subject { rendered }

  it { should have_selector("h2", :content => mock_section.title) }
end
