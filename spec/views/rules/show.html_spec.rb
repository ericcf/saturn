require 'spec_helper'

describe "rules/show.html" do

  before(:each) do
    assign(:daily_shift_count_rules, [])
    should_render_partial("schedules/section_menu")
    @mock_section = assign(:section, stub_model(Section))
    view.stub!(:nav_item)
  end

  context "max weekly shift duration is nil" do

    it "renders message indicating no limit" do
      render
      rendered.should contain("No maximum")
    end
  end

  context "max weekly shift duration is not nil" do

    it "renders message indicating limit" do
      assign(:weekly_shift_duration_rule,
        stub_model(WeeklyShiftDurationRule, :maximum => 5.0))
      render
      rendered.should contain("Maximum: 5.0")
    end
  end

  context "min weekly shift duration is nil" do

    it "renders message indicating no limit" do
      render
      rendered.should contain("No minimum")
    end
  end

  context "min weekly shift duration is not nil" do

    it "renders message indicating limit" do
      assign(:weekly_shift_duration_rule,
        stub_model(WeeklyShiftDurationRule, :minimum => 5.0))
      render
      rendered.should contain("Minimum: 5.0")
    end
  end

  context "max daily shift count is nil for a tag" do

    it "does not render the tag" do
      mock_shift_tag = stub_model(ShiftTag, :title => "Shifty")
      @mock_section.stub!(:shift_tags).and_return([mock_shift_tag])
      assign(:daily_shift_count_rules,
        [stub_model(DailyShiftCountRule, :shift_tag => mock_shift_tag)])
      render
      rendered.should_not contain(mock_shift_tag.title)
    end
  end

  context "max daily shift count is not for a tag" do

    it "renders the tag and the limit" do
      mock_shift_tag = stub_model(ShiftTag, :title => "Shifty")
      @mock_section.stub!(:shift_tags).and_return([mock_shift_tag])
      assign(:daily_shift_count_rules,
        [stub_model(DailyShiftCountRule, :shift_tag => mock_shift_tag, :maximum => 2)])
      render
      rendered.should contain("#{mock_shift_tag.title}: 2")
    end
  end
end
