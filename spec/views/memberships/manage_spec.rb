require 'spec_helper'

describe "memberships/manage" do

  def mock_section(stubs={})
    @mock_section ||= mock_model(Section, stubs)
  end

  before(:each) do
    @mock_section = assign(:section, mock_section)
    @mock_person = stub_model(Physician, :full_name => "B. Favre")
    assign(:members_by_group, { "Group 1" => [@mock_person] })
    should_render_partial("schedules/section_menu")
  end

  it "renders a link to add new members" do
    render
    rendered.should have_selector("a",
      :href => manage_new_section_memberships_path(@mock_section),
      :content => "Add Members"
    )
  end

  it "renders a form for updating section members" do
    render
    rendered.should have_selector("form",
      :action => section_path(@mock_section),
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
      label.should contain(@mock_person.full_name)
    end
  end

  it "renders fields to destroy members" do
    Section.delete_all
    section = assign(:section, Factory(:section))
    @mock_person.stub_chain(:section_memberships, :where, :first).
      and_return(stub_model(SectionMembership))
    render
    rendered.should have_selector("form input",
      :type => "checkbox",
      :name => "section[memberships_attributes][0][_destroy]"
    )
  end
end
