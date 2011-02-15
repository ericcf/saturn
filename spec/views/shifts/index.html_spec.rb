require 'spec_helper'

describe "shifts/index.html" do
  
  before(:each) do
    Section.delete_all
    @section = Factory(:section)
    assign(:section, @section)
    @mock_current_shift = stub_model(Shift, :title => "AM Duty",
      :retired_on => nil, :phone => "(123) 456-7890",
      :description => "Lorem ipsum...", :position => 1)
    @mock_current_shift.stub!(:tags).and_return("AM")
    @mock_retired_shift = stub_model(Shift, :title => "PM Duty",
      :retired_on => Date.yesterday)
    @mock_retired_shift.stub!(:tags).and_return("PM")
    assign(:current_shifts, [@mock_current_shift])
    assign(:retired_shifts, [@mock_retired_shift])
    should_render_partial("schedules/section_menu.html")
    render
  end

  subject { rendered }

  it "renders a link to add a new shift" do
    should have_selector("a",
      :href => new_section_shift_path(@section),
      :content => "Add Shift"
    )
  end

  it "renders hidden redirect_path field" do
    should have_selector("form input",
      :type => "hidden",
      :name => "redirect_path",
      :value => section_shifts_path(@section)
    )
  end

  it "renders title field" do
    should have_selector("form") do |form|
      form.should have_selector("input", :type => "text", :name => "section[shifts_attributes][0][title]", :value => @mock_current_shift.title)
    end
  end

  it "renders tags field" do
    should have_selector("form") do |form|
      form.should have_selector("input", :type => "text", :name => "section[shifts_attributes][0][tags]", :value => @mock_current_shift.tags)
    end
  end

  it "renders duration field" do
    should have_selector("form") do |form|
      form.should have_selector("select", :name => "section[shifts_attributes][0][duration]")
    end
  end

  it "renders phone field" do
    should have_selector("form") do |form|
      form.should have_selector("input", :type => "text", :name => "section[shifts_attributes][0][phone]", :value => @mock_current_shift.phone)
    end
  end

  it "renders description field" do
    should have_selector("form") do |form|
      form.should have_selector("input", :type => "text", :name => "section[shifts_attributes][0][description]", :value => @mock_current_shift.description)
    end
  end

  it "renders display color field" do
    should have_selector("form input",
      :type => "text",
      :name => "section[shifts_attributes][0][display_color]"
    )
  end

  it "renders retire field" do
    should have_selector("form input",
      :type => "checkbox",
      :name => "section[shifts_attributes][0][retire]"
    )
  end

  it "renders position field" do
    should have_selector("form") do |form|
      form.should have_selector("input", :type => "hidden", :name => "section[shifts_attributes][0][position]", :value => @mock_current_shift.position.to_s)
    end
  end

  it "renders the retired shift titles" do
    should have_selector("tr") do |form|
      form.should have_selector("td", :content => @mock_retired_shift.title)
    end
  end
end
