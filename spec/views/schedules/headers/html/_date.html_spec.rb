require 'spec_helper'

describe "schedules/headers/html/_date.html" do

  it do
    date = Date.today
    render :partial => "schedules/headers/html/date.html",
      :locals => { :date => date }
    rendered.should contain(date.to_s(:short_with_weekday))
  end
end
