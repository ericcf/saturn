require 'spec_helper'

describe "sections/_form" do

  def mock_section(stubs={})
    @mock_section ||= stub_model(Section, stubs)
  end

  it "renders a form for creating if the record is new" do
    assign(:section, mock_section.as_new_record)
    render
    rendered.should have_selector("form", :action => sections_path)
  end

  it "renders a form for updating if the record is not new" do
    assign(:section, mock_section)
    render
    rendered.should have_selector("form", :action => section_path(mock_section))
  end

  it "renders a label and field for the title" do
    assign(:section, mock_section(:title => "Foo"))
    render
    rendered.should have_selector("label", :for => "section_title")
    rendered.should have_selector("input", :type => "text", :name => "section[title]", :value => mock_section.title)
  end

  it "renders a label and field for the description" do
    assign(:section, mock_section(:description => "Lorem ipsum..."))
    render
    rendered.should have_selector("label", :for => "section_description")
    rendered.should have_selector("textarea", :name => "section[description]", :content => mock_section.description)
  end

  it "renders a submit button" do
    assign(:section, mock_section)
    render
    rendered.should have_selector("input", :type => "submit")
  end
end
