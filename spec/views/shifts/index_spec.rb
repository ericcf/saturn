require 'spec_helper'

describe "shifts/index" do
  
  before(:each) do
    Section.delete_all
    @section = Factory(:section)
    assign(:section, @section)
    @mock_current_shift = stub_model(Shift, :title => "AM Duty",
      :retired_on => nil)
    @mock_current_shift.stub!(:tags).and_return("AM")
    @mock_retired_shift = stub_model(Shift, :title => "PM Duty",
      :retired_on => Date.yesterday)
    @mock_retired_shift.stub!(:tags).and_return("PM")
    assign(:current_shifts, [@mock_current_shift])
    assign(:retired_shifts, [@mock_retired_shift])
    should_render_partial("schedules/section_menu")
  end

  it "renders a link to add a new shift" do
    render
    rendered.should have_selector("a",
      :href => new_section_shift_path(@section),
      :content => "Add Shift"
    )
  end

  it "renders hidden redirect_path field" do
    render
    rendered.should have_selector("form input",
      :type => "hidden",
      :name => "redirect_path",
      :value => section_shifts_path(@section)
    )
  end

  it "renders title field" do
    render
    rendered.should have_selector("form") do |form|
      form.should have_selector("input", :type => "text", :name => "section[shifts_attributes][0][title]", :value => @mock_current_shift.title)
    end
  end

  it "renders tags field" do
    render
    rendered.should have_selector("form") do |form|
      form.should have_selector("input", :type => "text", :name => "section[shifts_attributes][0][tags]", :value => @mock_current_shift.tags)
    end
  end

  it "renders duration field" do
    render
    rendered.should have_selector("form") do |form|
      form.should have_selector("select", :name => "section[shifts_attributes][0][duration]")
    end
  end

  it "renders phone field" do
    @mock_current_shift.stub!(:phone).and_return("(123) 456-7890")
    render
    rendered.should have_selector("form") do |form|
      form.should have_selector("input", :type => "text", :name => "section[shifts_attributes][0][phone]", :value => @mock_current_shift.phone)
    end
  end

  it "renders description field" do
    @mock_current_shift.stub!(:description).and_return("Lorem ipsum...")
    render
    rendered.should have_selector("form") do |form|
      form.should have_selector("input", :type => "text", :name => "section[shifts_attributes][0][description]", :value => @mock_current_shift.description)
    end
  end

  it "renders retire field" do
    render
    rendered.should have_selector("form input",
      :type => "checkbox",
      :name => "section[shifts_attributes][0][retire]"
    )
  end

  it "renders position field" do
    @mock_current_shift.stub!(:position).and_return(1)
    render
    rendered.should have_selector("form") do |form|
      form.should have_selector("input", :type => "hidden", :name => "section[shifts_attributes][0][position]", :value => @mock_current_shift.position.to_s)
    end
  end

  it "renders the retired shift titles" do
    render
    rendered.should have_selector("tr") do |form|
      form.should have_selector("td", :content => @mock_retired_shift.title)
    end
  end
end
