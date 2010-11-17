require 'spec_helper'

describe "memberships/manage_new" do

  before(:each) do
    @mock_section = assign(:section, mock_model(Section).as_null_object)
    assign(:membership,
      stub_model(SectionMembership, :section_id => @mock_section.id).as_new_record)
    @mock_physician = stub_model(Physician)
    assign(:physicians, [@mock_physician])
    should_render_partial("schedules/section_menu")
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

  it "renders a checkbox for each physician" do
    rendered.should have_selector("form input",
      :type => "checkbox",
      :name => "section[memberships_attributes][][physician_id]",
      :value => @mock_physician.id.to_s
    )
  end
end
