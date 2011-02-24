require 'spec_helper'

describe "physicians/_request_detail_row.html" do

  let(:mock_request) do
    stub("request",
      :section_title => "Foo",
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
      row.should have_selector("td", :content => mock_request.section_title)
      row.should have_selector("td a", :content => mock_request.start_date.to_s(:rfc822))
      row.should have_selector("td", :content => mock_request.status)
    end
  end
end
