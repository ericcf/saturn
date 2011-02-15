require 'spec_helper'

describe "shift_tags/_form.html" do

  before(:each) do
    @mock_section = assign(:section, stub_model(Section))
    assign(:shift_tag, stub_model(ShiftTag).as_new_record)
    should_render_partial("schedules/section_menu.html")
    render
  end

  it "renders a hidden field with the redirect_path" do
    rendered.should have_selector("form input",
      :type => "hidden",
      :name => "redirect_path",
      :value => section_shift_tags_path(@mock_section)
    )
  end

  it "renders a form field for the title" do
    rendered.should have_selector("form") do |form|
      form.should have_selector("input",
        :type => "text",
        :name => "shift_tag[title]"
      )
    end
  end

  it "renders a submit button" do
    rendered.should have_selector("form") do |form|
      form.should have_selector("input", :type => "submit")
    end
  end
end
