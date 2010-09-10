require 'spec_helper'

describe "schedules/show_weekly_section.haml" do

  before(:each) do
    @mock_section = assign(:section, stub_model(Section))
    @dates = assign(:dates, [Date.today])
    @note = { :shift => "Shift", :day => "Mon", :initials => "AB", :text => "Foo" }
    assign(:notes, [@note])
    assign(:schedule_view, TabularView.new)
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
    rendered.should have_selector("div.navcontainer ul.navlist.tableNavList") do |navlist|
      navlist.should have_selector("li a", :content => "shifts on left")
      navlist.should have_selector("li a", :content => "people on left")
    end
  end
end
