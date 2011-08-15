require 'spec_helper'

describe "memberships/manage_new.html" do

  let(:mock_section) { mock_model(Section).as_null_object }
  let(:mock_physician) { mock_model(Physician, :full_name => "X Y") }

  before(:each) do
    assign(:section, mock_section)
    assign(:physicians, [mock_physician])
    render
  end

  it "renders a form for creating a membership" do
    rendered.should have_selector("form",
      :action => section_path(mock_section),
      :method => "post"
    ) do |form|
      form.should have_selector("input", :type => "submit")
    end
  end

  it "renders a checkbox for each physician" do
    rendered.should have_selector("form input",
      :type => "checkbox",
      :name => "section[memberships_attributes][][physician_id]",
      :value => mock_physician.id.to_s
    )
  end
end
