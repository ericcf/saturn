require 'spec_helper'

describe "physician_aliases/_form.html" do

  let(:mock_alias) do
    mock_model(PhysicianAlias, :short_name => nil, :initials => "AB")
  end
  let(:mock_physician) do
    mock_model(Physician, :names_alias => mock_alias, :full_name => "A Bee")
  end

  before(:each) do
    render "physician_aliases/form", :physician => mock_physician,
      :physician_alias => mock_alias
  end

  subject { rendered }

  it "renders a form for updating the alias" do
    should have_selector("form",
      :action => physician_physician_alias_path(mock_physician),
      :method => "post"
    ) do |form|
      form.should have_selector("input", :type => "submit")
    end
  end

  it "renders a label for initials" do
    should have_selector("label", :content => "Initials")
  end
end
