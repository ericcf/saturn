require 'spec_helper'

describe "schedules/_date_header" do

  it "renders a th with the formatted date" do
    date = Date.today.to_s
    view.should_receive(:short_date).with(date).and_return("the date")
    view.should_receive(:date_header).any_number_of_times.and_return(date)
    render
    rendered.should have_selector("th", :class => "date") do |th|
      th.should have_selector("span", :class => "date_value", :content => date)
      th.should have_selector("span",
        :class => "date_string",
        :content => "the date"
      )
    end
  end
end
