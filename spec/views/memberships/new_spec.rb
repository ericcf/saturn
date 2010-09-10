require 'spec_helper'

describe "memberships/new" do

  before(:each) do
    @mock_section = assign(:section, mock_model(Section).as_null_object)
    assign(:membership,
      stub_model(SectionMembership, :section_id => @mock_section.id).as_new_record)
    @mock_person = stub_model(Person)
    assign(:people, [@mock_person])
    render
  end

  it "renders a form for creating a membership" do
    rendered.should have_selector("form",
      :action => section_path(@mock_section),
      :method => "post"
    ) do |form|
      form.should have_selector("input", :type => "submit")
    end
  end

  it "renders a checkbox for each person" do
    rendered.should have_selector("form input",
      :type => "checkbox",
      :name => "section[memberships_attributes][][person_id]",
      :value => @mock_person.id.to_s
    )
  end
end
