require 'spec_helper'

describe Conference do

  let(:today) { DateTime.now }
  let(:valid_attributes) do
    {
      :title => "Meeting of the Century",
      :starts_at => today,
      :ends_at => today
    }
  end
  let(:conference) { Conference.create!(valid_attributes) }

  subject { conference }

  # database
  
  it { should have_db_column(:title).with_options(:null => false) }
  
  it { should have_db_column(:starts_at).with_options(:null => false) }

  it { should have_db_column(:ends_at).with_options(:null => false) }

  it { should have_db_index(:external_uid).unique(true) }

  it { should have_db_index([:title, :starts_at, :ends_at]).unique(true) }

  # validations

  it { should allow_value(nil).for(:external_uid) }

  it "validates uniqueness of external_uid" do
    conference.update_attribute(:external_uid, "UID")
    Conference.new(:external_uid => "UID").
      should have(1).errors_on(:external_uid)
  end

  it { should validate_presence_of(:title) }

  it { should validate_presence_of(:starts_at) }

  it { should validate_presence_of(:ends_at) }

  it "validates uniqueness of title scoped to starts_at and ends_at" do
    conference_dup = Conference.new(:title => conference.title,
      :starts_at => conference.starts_at,
      :ends_at => conference.ends_at)
    conference_dup.should have(1).errors_on(:title)
  end

  # methods

  describe "#occur_on(:date)" do

    it "returns conferences which occur on the specified date" do
      today = Date.today
      conference = Conference.create(valid_attributes.merge({
        :title => "Conference Today!",
        :starts_at => today.to_time,
        :ends_at => today.to_time
      }))
      Conference.occur_on(today).should include(conference)
    end
  end
end
