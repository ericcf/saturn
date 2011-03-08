require 'spec_helper'

describe "sections/_form.html" do

  let(:mock_section) { mock_model(Section, :title => "Foo") }

  before(:each) do
    render "sections/form", :section => mock_section
  end

  subject { rendered }

  it "renders a form for the section" do
    should have_selector("form", :action => section_path(mock_section))
  end

  it "renders a label and field for the title" do
    should have_selector("label", :for => "section_title")
    should have_selector("input", :type => "text", :name => "section[title]", :value => mock_section.title)
  end

  it "renders a submit button" do
    should have_selector("input", :type => "submit")
  end
end
