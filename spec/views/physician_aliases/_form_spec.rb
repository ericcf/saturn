require 'spec_helper'

describe "physician_aliases/_form" do

  def mock_physician(stubs={})
    @mock_physician ||= stub_model(Physician, stubs).as_null_object
  end

  def mock_physician_alias(stubs={})
    @mock_physician_alias ||= stub_model(PhysicianAlias, stubs).as_null_object
  end

  it "renders a form for updating the alias" do
    assign(:physician_alias, mock_physician_alias(:short_name => nil, :initials => nil))
    assign(:physician, mock_physician)
    render
    rendered.should have_selector("form",
      :action => physician_physician_alias_path(mock_physician),
      :method => "post"
    ) do |form|
      form.should have_selector("input", :type => "submit")
    end
  end

  it "renders a label for initials" do
    assign(:physician_alias, mock_physician_alias(:short_name => nil, :initials => "AB"))
    assign(:physician, mock_physician(:names_alias => mock_physician_alias))
    render
    rendered.should have_selector("label", :content => "Initials")
  end
end
