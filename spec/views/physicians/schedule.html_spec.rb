require 'spec_helper'

describe "physicians/schedule.html" do

  let(:mock_physician) { stub_model(Physician, :full_name => "Foo Bar") }
  let(:mock_schedule) do
    stub_model(::Logical::PhysicianSchedule, :dates => [Date.today])
  end

  before(:each) do
    assign(:physician, mock_physician)
    mock_schedule.stub!(:assignments_for_section_and_date)
    assign(:schedule, mock_schedule)
    render
  end

  subject { rendered }

  it { should have_selector("h2", :content => mock_physician.full_name) }

  it do
    should have_selector("h3",
      :content => "Published Schedule #{mock_schedule.dates.first.to_s(:long)} - #{mock_schedule.dates.last.to_s(:long)}")
  end

  it do
    should have_selector("form",
      :method => "get",
      :action => schedule_physician_path(mock_physician)
    ) do |form|
      form.should have_selector("select", :name => "date[year]")
      form.should have_selector("select", :name => "date[month]")
      form.should have_selector("select", :name => "date[day]")
    end
  end
end
