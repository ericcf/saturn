require 'spec_helper'

describe "schedules/daily_duty_roster" do

  before(:each) do
    @today = Date.today
    assign(:week_start_date, @today)
    assign(:date, @today)
    assign(:clinical_shifts, [])
    assign(:clinical_assignments, [])
    assign(:sections, [])
    assign(:notes, [])
  end

  it "renders @date" do
    render
    rendered.should have_selector("h3", :content => @today.to_s(:long))
  end

  it "renders a div for each section" do
    assign(:sections, [
      mock_model(Section, :title => "A Section", :people_with_associations => []),
      mock_model(Section, :title => "B Section", :people_with_associations => [])
    ])
    render
    rendered.should have_selector("div.section > h4", :content => "A Section")
    rendered.should have_selector("div.section > h4", :content => "B Section")
  end

  #context "with populated call shifts" do

  #  before(:each) do
  #    @call_shifts = assigns[:call_shifts] = [
  #      mock_model(Shift, :title => "Shift A"),
  #      mock_model(Shift, :title => "Shift B")
  #    ]
  #  end

  #  it "renders the call shift titles on the rows from @call_shifts" do
  #    render
  #    response.should have_tag("table") do
  #      with_tag("tr > td", "Shift A")
  #      with_tag("tr > td", "Shift B")
  #    end
  #  end

  #  it "renders the assignments corresponding to the shifts and dates" do
  #    mock_person = stub('Person', :short_name => "L. Effant")
  #    assigns[:call_assignments] = [
  #      mock_model(Assignment,
  #                 :person => mock_person,
  #                 :shift_id => @call_shifts.first.id,
  #                 :date => @today)
  #    ]
  #    render
  #    response.should have_tag("table") do
  #      with_tag("tr > td", mock_person.short_name)
  #    end
  #  end
  #end
end
