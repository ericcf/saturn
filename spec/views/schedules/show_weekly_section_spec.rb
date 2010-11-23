require 'spec_helper'

describe "schedules/show_weekly_section.haml" do

  before(:each) do
    @mock_section = assign(:section, stub_model(Section))
    @dates = assign(:dates, [Date.today])
    @note = { :shift => "Shift", :day => "Mon", :initials => "AB", :text => "Foo" }
    assign(:notes, [@note])
    assign(:schedule_presenter, stub("presenter", :each_col_header => nil, :each_row => nil))
    should_render_partial("section_menu")
    should_render_partial("rules_conflicts")
    render
  end

  subject { rendered }

  it {
    should have_selector("form",
      :action => weekly_section_schedule_path(@mock_section),
      :method => "get"
    )
  }

  it { should have_selector("form input", :type => "text", :name => "date") }

  it {
    should have_selector("a",
      :href => weekly_section_schedule_path(@mock_section, :format => :xls, :date => @dates.first.to_s, :view_mode => nil),
      :content => "Download as Excel"
    )
  }

  it {
    should have_selector("ul.notes li",
      :content => "#{@note[:shift]} on #{@note[:day]}, #{@note[:initials]}: #{@note[:text]}"
    )
  }

  it {
    should have_selector("table.schedule thead") do |table_head|
      table_head.should have_selector("th a", :content => "View by Physician")
    end
  }
end
