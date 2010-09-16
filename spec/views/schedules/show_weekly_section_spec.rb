require 'spec_helper'

describe "schedules/show_weekly_section.haml" do

  before(:each) do
    @mock_section = assign(:section, stub_model(Section))
    @dates = assign(:dates, [Date.today])
    @note = { :shift => "Shift", :day => "Mon", :initials => "AB", :text => "Foo" }
    assign(:notes, [@note])
    assign(:schedule_view, TabularView.new)
    should_render_partial("section_menu")
    render
  end

  it "renders a form for selecting a date" do
    rendered.should have_selector("form",
      :action => weekly_section_schedule_path(@mock_section),
      :method => "get"
    )
  end

  it "renders a field for selecting a date" do
    rendered.should have_selector("form input",
      :type => "text",
      :name => "date"
    )
  end

  it do
    rendered.should have_selector("a",
      :href => weekly_section_schedule_path(@mock_section, :format => :xls, :date => @dates.first.to_s, :view_mode => nil),
      :content => "Download as Excel"
    )
  end

  it do
    rendered.should have_selector("ul.notes li",
      :content => "#{@note[:shift]} on #{@note[:day]}, #{@note[:initials]}: #{@note[:text]}"
    )
  end

  it do
    rendered.should have_selector("table.schedule thead") do |table_head|
      table_head.should have_selector("th a", :content => "people on left")
    end
  end
end
