require 'spec_helper'

describe "schedules/_assignment" do

  before(:each) do
    @shift = mock_model(Shift)
    @date = Date.today.to_s
  end

  it "renders a span with the person's short name" do
    person = mock_model(Physician)
    people_names = { person.id => "A. Jones" }
    view.should_receive(:assignment).any_number_of_times.
      and_return(stub_model(Assignment, :physician_id => person.id))
    view.should_receive(:shift).any_number_of_times.and_return(@shift)
    view.should_receive(:date).any_number_of_times.and_return(@date)
    view.should_receive(:people_names).any_number_of_times.
      and_return(people_names)
    render
    rendered.should have_selector("span",
      :class => "person_name",
      :content => "A. Jones"
    )
  end
end
