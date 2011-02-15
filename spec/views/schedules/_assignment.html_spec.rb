require 'spec_helper'

describe "schedules/_assignment.html" do

  before(:each) do
    @shift = mock_model(Shift)
    @date = Date.today.to_s
  end

  it "renders a span with the person's short name" do
    person = mock_model(Physician)
    render :partial => "schedules/assignment.html", :locals => {
      :shift => @shift,
      :date => @date,
      :assignment => stub_model(Assignment, :physician_id => person.id),
      :people_names => { person.id => "A. Jones" }
    }
    rendered.should have_selector("span",
      :class => "person_name",
      :content => "A. Jones"
    )
  end
end
