require 'spec_helper'

describe ::Logical::RulesConflictSummary do

  let(:mock_section) { stub_model(Section) }
  let(:mock_weekly_schedule) { stub_model(WeeklySchedule) }
  let(:mock_physician) { stub_model(Physician) }
  let(:mock_assignment) { stub_model(Assignment) }
  let(:valid_attributes) do
    {
      :section => mock_section,
      :weekly_schedule => mock_weekly_schedule,
      :assignments => [mock_assignment],
      :ordered_physician_ids => [mock_physician.id]
    }
  end
  let(:summary) { ::Logical::RulesConflictSummary.new(valid_attributes) }

  subject { summary }

  # validations

  it do
    ::Logical::RulesConflictSummary.new(:section => nil).
      should have(1).error_on(:section)
  end

  it do
    ::Logical::RulesConflictSummary.new(:weekly_schedule => nil).
      should have(1).error_on(:weekly_schedule)
  end

  it do
    ::Logical::RulesConflictSummary.new(:assignments => nil).
      should have(1).error_on(:assignments)
  end

  it do
    ::Logical::RulesConflictSummary.new(:ordered_physician_ids => nil).
      should have(1).error_on(:ordered_physician_ids)
  end

  # methods

  describe "#to_json" do

    it "returns valid json" do
      expect { JSON.parse summary.to_json }.
        to_not raise_error(JSON::ParserError)
    end
  end
end
