require 'spec_helper'

describe "reports/headers/_physician.html" do

  let(:mock_section) { stub_model(Section) }
  let(:mock_physician) do
    stub_model(Physician, :full_name => "Foo", :initials => "F")
  end

  before(:each) do
    render "reports/headers/physician",
      :section => mock_section,
      :group_name => "Bar",
      :physician => mock_physician,
      :start_date => Date.today,
      :end_date => Date.tomorrow
  end

  subject { rendered }

  it do
    should have_selector("th.physician_name a",
      :content => mock_physician.initials
    )
  end
end
