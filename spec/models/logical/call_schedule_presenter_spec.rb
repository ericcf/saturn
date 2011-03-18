require 'spec_helper'

describe ::Logical::CallSchedulePresenter do

  let(:today) { Date.today }
  let(:mock_section) { mock_model(Section) }
  let(:mock_shift) { mock_model(Shift) }
  let(:mock_physician) { mock_model(Physician, :short_name => "Wile E. Coyote") }
  let(:mock_assignment) do
    mock_model(Assignment,
      :public_note => "Foo",
      :duration => 1.0,
      :shift_id => mock_shift.id,
      :date => today,
      :physician_id => mock_physician.id
    )
  end
  let(:valid_attributes) do
    {
      :dates => [today]
    }
  end
  let(:presenter) { ::Logical::CallSchedulePresenter.new(valid_attributes) }

  before(:each) do
    Physician.stub_chain("includes.hash_by_id").
      and_return({ mock_physician.id => mock_physician })
  end

  subject { presenter }

  it { should be_valid }

  # validations

  it "validates presence of dates" do
    ::Logical::CallSchedulePresenter.new(:dates => nil).
      should have(1).error_on(:dates)
  end

  # methods

  describe "#summaries_by_section_id_shift_id_and_date(:section_id, :shift_id, :date)" do

    context "there is not an associated published schedule" do

      it "returns an empty array" do
        presenter.summaries_by_section_id_shift_id_and_date(mock_section.id,
          mock_shift.id, today).should == []
      end
    end

    context "there is an associated published schedule" do

      before(:each) do
        Section.stub!(:all) { [mock_section] }
        mock_section.stub!(:published_assignments_by_dates).
          with([today]).
          and_return([mock_assignment])
      end

      it "returns a summary of the assignments" do
        presenter.summaries_by_section_id_shift_id_and_date(mock_section.id,
          mock_shift.id, today).should == [
            {
              :text => mock_physician.short_name,
              :note => mock_assignment.public_note,
              :duration => mock_assignment.duration
            }
          ]
      end
    end
  end
end
