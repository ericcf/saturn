require 'spec_helper'

describe "call_shifts/_form.html" do

  let(:mock_section) { stub_model(Section) }
  let(:mock_call_shift) { stub_model(CallShift) }

  before(:each) do
    assign(:section, mock_section)
    assign(:call_shift, mock_call_shift)
    should_render_partial("schedules/section_menu.html")
    render
  end

  subject { rendered }

  it "renders a form for creating a call shift" do
    should have_selector("form",
      :action => section_call_shift_path(mock_section, mock_call_shift),
      :method => "post"
    ) do |form|
      form.should have_selector("input", :type => "submit")
    end
  end

  it "renders a field for the title" do
    should have_selector("form input",
      :type => "text",
      :name => "call_shift[title]"
    )
  end

  it "renders a fieldset to select shared sections when not a new record" do
    should have_selector("form input",
      :name => "call_shift[section_ids][]"
    )
  end
end
