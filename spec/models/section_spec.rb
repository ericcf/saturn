require 'spec_helper'

describe Section do

  let(:valid_attributes) do
    {
      :title => "Foo"
    }
  end
  let(:section) { Section.create!(valid_attributes) }

  # database

  it { should have_db_column(:title).with_options(:null => false) }

  it { should have_db_index(:title).unique(true) }

  # associations

  it { should have_many(:shift_tags).dependent(:destroy) }

  it { should have_many(:memberships).dependent(:destroy) }

  it { should have_many(:weekly_schedules).dependent(:destroy) }

  it { should have_many(:shifts).dependent(:destroy) }

  it { should have_many(:vacation_requests).dependent(:destroy) }

  it { should have_one(:weekly_shift_duration_rule).dependent(:destroy) }

  it { should have_many(:daily_shift_count_rules).dependent(:destroy) }

  it { should have_one(:section_role_assignment).dependent(:destroy) }

  it { should have_one(:admin_role).through(:section_role_assignment) }

  # validations

  it { should validate_presence_of(:title) }

  it { @section = section; should validate_uniqueness_of(:title) }

  # attribute cleanup

  it { should clean_text_attribute(:title) }

  # methods

  describe ".create_admin_role" do

    it "creates a role with permission to manage the section" do
      mock_permission = stub_model(Deadbolt::Permission)
      Deadbolt::Permission.stub!(:find_or_create_by_action_and_target_type).
        with("manage", "Section").
        and_return(mock_permission)
      mock_admin_role = stub_model(Deadbolt::Role)
      mock_permission.stub_chain("roles.find_or_create_by_name").
        and_return(mock_admin_role)
      mock_admin_role.stub_chain("role_permissions.first.update_attributes")
      section.create_admin_role.should eq(mock_admin_role)
    end
  end

  describe ".vacation_shift" do

    it "returns an associated shift with the title 'Vacation'" do
      vacation_shift = section.shifts.create(:title => "Vacation")
      section.vacation_shift.should eq(vacation_shift)
    end
  end

  describe ".find_or_create_weekly_schedule_by_included_date(:date)" do

    let(:mock_schedule) { stub_model(WeeklySchedule) }
    let(:mock_schedules_assoc) { stub("schedules") }
    let(:date) { Date.today }

    before(:each) { section.stub!(:weekly_schedules) { mock_schedules_assoc } }

    it "returns a weekly schedule that includes the date" do
      mock_schedules_assoc.stub!(:include_date).with(date) { [mock_schedule] }
      section.find_or_create_weekly_schedule_by_included_date(date).
        should eq(mock_schedule)
    end

    it "returns a new weekly schedule when none include the date" do
      monday_before_date = date.at_beginning_of_week
      mock_schedules_assoc.should_receive(:create).
        with(:date => monday_before_date).
        and_return(mock_schedule)
      mock_schedules_assoc.stub!(:include_date).with(date) { [] }
      section.find_or_create_weekly_schedule_by_included_date(date).
        should eq(mock_schedule)
    end
  end
end
