require 'spec_helper'

describe WeeklySchedulePresenter do

  before(:each) do
    @mock_section = stub_model(Section)
    @dates = [Date.yesterday, Date.today]
    mock_physician = stub_model(Physician, :short_name => "S. Gonzalez")
    Physician.stub_chain(:with_assignments, :includes, :hash_by_id).
      and_return({ mock_physician.id => mock_physician })
    mock_shift = stub_model(Shift, :title => "Conference")
    @mock_assignments = [
      stub_model(Assignment, :shift => mock_shift, :physician_id => mock_physician.id),
      stub_model(Assignment, :shift => mock_shift, :physician_id => mock_physician.id)
    ]
  end

  it "passes a smoke test" do
    WeeklySchedulePresenter.new(@mock_section, @dates,
      @mock_assignments, { :col_type => :dates, :row_type => :shifts })
    WeeklySchedulePresenter.new(@mock_section, @dates,
      @mock_assignments, { :col_type => :dates, :row_type => :physicians })
  end
end
