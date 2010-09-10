require 'spec_helper'

describe "people/index" do

  def mock_person(stubs={})
    @mock_person ||= stub_model(Person, stubs)
  end

  it "renders a link to view each person's schedule" do
    mock_section = stub_model(Section)
    mock_person(
      :full_name => "IP Daily",
      :short_name => "I. Daily",
      :initials => "ID",
      :sections => [mock_section]
    )
    assign(:people, [mock_person])
    render
    rendered.should have_selector("a",
      :href => schedule_person_path(mock_person),
      :content => mock_person.full_name,
      :title => "View Schedule"
    )
  end
end
