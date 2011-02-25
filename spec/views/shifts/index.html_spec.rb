require 'spec_helper'

describe "shifts/index.html" do
  
  let(:mock_current_shift) do
    mock_model(Shift,
      :title => "AM Duty",
      :retired_on => nil,
      :phone => "(123) 456-7890",
      :description => "Lorem ipsum...",
      :position => 1,
      :tags => "AM"
    ).as_null_object
  end
  let(:mock_retired_shift) do
    mock_model(Shift,
      :title => "PM Duty",
      :retired_on => Date.yesterday,
      :tags => "PM"
    ).as_null_object
  end
  let(:mock_section_shifts) do
    [
      stub_model(SectionShift, :shift_id => mock_current_shift.id),
      stub_model(SectionShift, :shift_id => mock_retired_shift.id)
    ]
  end
  let(:mock_section) do
    stub_model(Section, :section_shifts => mock_section_shifts)
  end

  before(:each) do
    Section.delete_all
    assign(:section, mock_section)
    assign(:current_shifts, [mock_current_shift])
    assign(:retired_shifts, [mock_retired_shift])
    should_render_partial("schedules/section_menu.html")
    render
  end

  subject { rendered }

  it "renders a link to add a new shift" do
    should have_selector("a",
      :href => new_section_shift_path(mock_section),
      :content => "Add Shift"
    )
  end

  it "renders hidden redirect_path field" do
    should have_selector("form input",
      :type => "hidden",
      :name => "redirect_path",
      :value => section_shifts_path(mock_section)
    )
  end

  it "renders title field" do
    should have_selector("form") do |form|
      form.should have_selector("input", :type => "text", :name => "section[shifts_attributes][0][title]", :value => mock_current_shift.title)
    end
  end

  it "renders tags field" do
    should have_selector("form") do |form|
      form.should have_selector("input", :type => "text", :name => "section[shifts_attributes][0][tags]", :value => mock_current_shift.tags)
    end
  end

  it "renders duration field" do
    should have_selector("form") do |form|
      form.should have_selector("select", :name => "section[shifts_attributes][0][duration]")
    end
  end

  it "renders phone field" do
    should have_selector("form") do |form|
      form.should have_selector("input", :type => "text", :name => "section[shifts_attributes][0][phone]", :value => mock_current_shift.phone)
    end
  end

  it "renders description field" do
    should have_selector("form") do |form|
      form.should have_selector("input", :type => "text", :name => "section[shifts_attributes][0][description]", :value => mock_current_shift.description)
    end
  end

  #it "renders display color field" do
  #  should have_selector("form input",
  #    :type => "text",
  #    :name => "section[shifts_attributes][0][display_color]"
  #  )
  #end

  #it "renders retire field" do
  #  should have_selector("form input",
  #    :type => "checkbox",
  #    :name => "section[shifts_attributes][0][retire]"
  #  )
  #end

  it "renders position field" do
    should have_selector("form") do |form|
      form.should have_selector("input", :type => "hidden", :name => "section[shifts_attributes][0][position]", :value => mock_current_shift.position.to_s)
    end
  end

  it "renders the retired shift titles" do
    should have_selector("tr") do |form|
      form.should have_selector("td", :content => mock_retired_shift.title)
    end
  end
end
