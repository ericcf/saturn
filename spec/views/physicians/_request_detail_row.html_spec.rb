require 'spec_helper'

describe "physicians/_request_detail_row.html" do

  let(:mock_section) { mock_model(Section, :title => "Foo") }
  let(:mock_shift) { mock_model(Shift, :title => "Bar") }
  let(:mock_request) do
    stub("request",
      :sections => [mock_section],
      :shift => mock_shift,
      :start_date => Date.today,
      :status => "under the weather"
    )
  end
  let(:mock_physician) { stub_model(Physician) }

  before(:each) do
    render :partial => "physicians/request_detail_row.html",
      :locals => { :request => mock_request, :physician => mock_physician }
  end

  subject { rendered }

  it do
    should have_selector("tr") do |row|
      row.should have_selector("td", :content => mock_section.title)
      row.should have_selector("td", :content => mock_shift.title)
      row.should have_selector("td a", :content => mock_request.start_date.to_s(:rfc822))
      row.should have_selector("td", :content => mock_request.status)
    end
  end
end
