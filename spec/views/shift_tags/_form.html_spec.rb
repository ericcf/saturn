require 'spec_helper'

describe "shift_tags/_form.html" do

  let(:mock_section) { stub_model(Section) }

  before(:each) do
    assign(:section, mock_section)
    assign(:shift_tag, stub_model(ShiftTag).as_new_record)
    render
  end

  subject { rendered }

  it "renders a hidden field with the redirect_path" do
    should have_selector("form input",
      :type => "hidden",
      :name => "redirect_path",
      :value => section_shift_tags_path(mock_section)
    )
  end

  it "renders a form field for the title" do
    should have_selector("form") do |form|
      form.should have_selector("input",
        :type => "text",
        :name => "shift_tag[title]"
      )
    end
  end

  it "renders a submit button" do
    should have_selector("form") do |form|
      form.should have_selector("input", :type => "submit")
    end
  end
end
