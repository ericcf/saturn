require 'spec_helper'

describe "memberships/manage.html" do

  let(:mock_section) { mock_model(Section, :title => "My Section") }
  let(:mock_person) do
    mock_model(Physician,
               :full_name => "B. Favre"
              )
  end

  before(:each) do
    assign(:section, mock_section)
    assign(:members_by_group, { "Group 1" => [mock_person] })
    mock_person.stub_chain("section_memberships.where") { [] }
  end

  it "renders a form for updating section members" do
    render
    rendered.should have_selector("form",
      :action => section_path(mock_section),
      :method => "post"
    ) do |form|
      form.should have_selector("input", :type => "submit")
    end
  end

  it "renders the title of each group" do
    render
    rendered.should have_selector("legend span", :content => "Group 1")
  end

  it "renders full names of members" do
    render
    rendered.should have_selector("label") do |label|
      label.should contain(mock_person.full_name)
    end
  end

  it "renders fields to destroy members" do
    section = assign(:section, mock_model(Section, :title => "Other Section"))
    mock_person.stub_chain(:section_memberships, :where, :first).
      and_return(mock_model(SectionMembership))
    render
    rendered.should have_selector("form input",
      :type => "checkbox",
      :name => "section[memberships][_destroy]"
    )
  end
end
