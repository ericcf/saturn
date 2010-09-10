require 'spec_helper'

describe "people/schedule" do

  before(:each) do
    @mock_person = assign(:person, stub_model(Person, :full_name => "Foo Bar"))
    @dates = assign(:dates, [Date.today])
    render
  end

  it { rendered.should have_selector("h2", :content => @mock_person.full_name) }

  it do
    rendered.should have_selector("h3",
      :content => "Week of #{@dates.first.to_s(:long)}")
  end

  it do
    rendered.should have_selector("form",
      :method => "get",
      :action => schedule_person_path(@mock_person)
    ) do |form|
      form.should have_selector("input",
        :type => "text",
        :name => "date"
      )
    end
  end
end
