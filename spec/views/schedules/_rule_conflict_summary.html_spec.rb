require 'spec_helper'

describe "schedules/_rule_conflict_summary.html" do

  let(:mock_physician) { stub("physician", :id => 1, :name => "One") }

  before(:each) do
    render :partial => "schedules/rule_conflict_summary.html",
      :locals => {
        :physician_names_by_id => { mock_physician.id => mock_physician.name },
        :summary => { :physician_id => mock_physician.id, :description => "foo" }
      }
  end

  subject { rendered }

  it { should have_selector("li", :content => "One (foo)") }
end
