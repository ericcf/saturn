require 'spec_helper'

describe "shifts/_form" do

  before(:each) do
    @mock_section = assign(:section, stub_model(Section))
    @mock_shift = assign(:shift, stub_model(Shift))
    should_render_partial("schedules/section_menu")
    render
  end

  subject { rendered }

  it "renders a form for creating a shift" do
    should have_selector("form",
      :action => section_shift_path(@mock_section, @mock_shift),
      :method => "post"
    ) do |form|
      form.should have_selector("input", :type => "submit")
    end
  end

  it "renders a field for the title" do
    should have_selector("form input",
      :type => "text",
      :name => "shift[title]"
    )
  end

  it "renders a field for the display color" do
    should have_selector("form input",
      :type => "text",
      :name => "shift[display_color]"
    )
  end
end
