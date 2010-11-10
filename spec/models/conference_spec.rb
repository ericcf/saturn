require 'spec_helper'

describe Conference do

  before(:each) do
    @valid_params = {
      :starts_at => DateTime.now,
      :ends_at => DateTime.now
    }
    @conference = Conference.create(@valid_params)
    @conference.should be_valid
  end

  # database
  
  it { should have_db_column(:starts_at).with_options(:null => false) }

  it { should have_db_column(:ends_at).with_options(:null => false) }

  it { should have_db_index(:external_uid).unique(true) }

  # validations

  it { should validate_uniqueness_of(:external_uid) }

  it { should validate_presence_of(:starts_at) }

  it { should validate_presence_of(:ends_at) }

  # methods

  describe "#occur_on(:date)" do

    it "returns conferences which occur on the specified date" do
      conference = Conference.create(:starts_at => DateTime.now,
        :ends_at => DateTime.now, :external_uid => "new uid")
      Conference.occur_on(Date.today).should include(conference)
    end
  end
end
