require 'spec_helper'

describe "physicians/index.html" do

  def mock_physician(stubs={})
    @mock_physician ||= stub_model(Physician, stubs)
  end

  it "renders a link to view each physician's schedule" do
    mock_section = stub_model(Section)
    mock_physician(
      :full_name => "IP Daily",
      :short_name => "I. Daily",
      :initials => "ID"
    )
    mock_physician.stub!(:sections).and_return([mock_section])
    assign(:physicians, [mock_physician])
    view.should_receive(:will_paginate).twice
    render
    rendered.should have_selector("td",
      :content => mock_physician.full_name
    )
  end
end
