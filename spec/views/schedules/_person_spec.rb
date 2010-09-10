require 'spec_helper'

describe "schedules/_person" do

  it "renders a div with the person's short name" do
    mock_person = mock_model(Person, :short_name => "J. Doe")
    view.should_receive(:person).any_number_of_times.and_return(mock_person)
    render
    rendered.should have_selector("div",
      :class => "person",
      :id => "person_#{mock_person.id}",
      :content => mock_person.short_name
    )
  end
end
