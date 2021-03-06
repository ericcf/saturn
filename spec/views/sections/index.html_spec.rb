require 'spec_helper'

describe "sections/index.html" do

  def mock_section(stubs={})
    @mock_section ||= mock_model(Section, stubs)
  end

  it "renders a link to each section schedule" do
    assign(:sections, [mock_section(:title => "The Best Section")])
    view.stub!(:can?)
    view.stub!(:nav_item)
    render
    rendered.should have_selector("a",
      :href => weekly_section_schedule_path(mock_section),
      :content => mock_section.title
    )
  end
end
