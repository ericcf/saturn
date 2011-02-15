require 'spec_helper'

describe "physicians/schedule.html" do

  before(:each) do
    @mock_physician = assign(:physician, stub_model(Physician, :full_name => "Foo Bar"))
    @dates = assign(:dates, [Date.today])
    render
  end

  it { rendered.should have_selector("h2", :content => @mock_physician.full_name) }

  it do
    rendered.should have_selector("h3",
      :content => "Week of #{@dates.first.to_s(:long)}")
  end

  it do
    rendered.should have_selector("form",
      :method => "get",
      :action => schedule_physician_path(@mock_physician)
    ) do |form|
      form.should have_selector("select", :name => "date[year]")
      form.should have_selector("select", :name => "date[month]")
      form.should have_selector("select", :name => "date[day]")
    end
  end
end
