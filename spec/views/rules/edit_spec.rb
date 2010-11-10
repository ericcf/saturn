require 'spec_helper'

describe "rules/edit" do

  before(:each) do
    @mock_section = assign(:section, stub_model(Section))
    mock_shift_tag = stub_model(ShiftTag, :title => "PM")
    mock_rule = stub_model(DailyShiftCountRule, :shift_tag => mock_shift_tag)
    assign(:daily_shift_count_rules, [mock_rule])
    should_render_partial("schedules/section_menu")
    render
  end

  it "renders a form for updating section rules" do
    rendered.should have_selector("form",
      :action => section_rules_path(@mock_section))
  end
end