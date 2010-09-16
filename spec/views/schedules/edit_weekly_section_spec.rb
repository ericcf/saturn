require 'spec_helper'

describe "schedules/edit_weekly_section" do

  before(:each) do
    @mock_section = assign(:section, stub_model(Section))
    assign(:week_start_date, Date.today)
    assign(:grouped_people, {})
    assign(:weekly_schedule, stub_model(WeeklySchedule))
    assign(:week_dates, [])
    assign(:assignments, [])
    assign(:people_names, {})
    assign(:shifts, [])
    should_render_partial("shift")
    should_render_partial("date_header")
    should_render_partial("group")
    should_render_partial("assignment")
    should_render_partial("section_menu")
    render
  end

  it "renders a form to change the schedule date" do
    rendered.should have_selector("form",
      :action => edit_weekly_section_schedule_path(@mock_section),
      :method => "get"
    )
  end

  it "renders a field for selecting a date" do
    rendered.should have_selector("form input",
      :type => "text",
      :name => "date"
    )
  end

  it "renders a form to save changes to the schedule" do
    rendered.should have_selector("form",
      :action => update_weekly_section_schedule_path(@mock_section),
      :method => "post"
    ) do |form|
      form.should have_selector("input", :type => "submit")
    end
  end

  it "renders a field for publishing" do
    rendered.should have_selector("form input",
      :type => "checkbox",
      :name => "weekly_schedule[publish]"
    )
  end
end
