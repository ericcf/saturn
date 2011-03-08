require 'spec_helper'

describe "rules/edit.html" do

  let(:mock_section) { stub_model(Section) }

  before(:each) do
    assign(:section, mock_section)
    mock_shift_tag = stub_model(ShiftTag, :title => "PM")
    mock_rule = stub_model(DailyShiftCountRule, :shift_tag => mock_shift_tag)
    assign(:daily_shift_count_rules, [mock_rule])
    render
  end

  it "renders a form for updating section rules" do
    rendered.should have_selector("form",
      :action => section_rules_path(mock_section))
  end
end
