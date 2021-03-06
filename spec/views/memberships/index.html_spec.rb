require 'spec_helper'

describe "memberships/index.html" do

  let(:mock_physician) { stub_model(Physician, :full_name => "Foo Bar") }

  before(:each) do
    assign(:section, stub_model(Section))
    assign(:members_by_group, { "Group 1" => [mock_physician] })
    view.stub!(:nav_item)
    render
  end

  subject { rendered }

  it { should have_selector("ul li", :content => mock_physician.full_name) }
end
