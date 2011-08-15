require 'spec_helper'

describe Section do

  let(:valid_attributes) do
    {
      :title => "Foo"
    }
  end
  let(:section) { Section.create!(valid_attributes) }

  subject { section }

  # database

  it { should have_db_column(:title).with_options(:null => false) }

  it { should have_db_index(:title).unique(true) }

  # associations

  it { should have_many(:shift_tags).dependent(:destroy) }

  it { should have_many(:memberships).dependent(:destroy) }

  it { should have_many(:weekly_schedules).dependent(:destroy) }

  it { should have_many(:section_shifts).dependent(:destroy) }

  it { should have_many(:shifts).through(:section_shifts) }

  it { should have_many(:call_shifts).through(:section_shifts) }

  it { should have_many(:vacation_shifts).through(:section_shifts) }

  it { should have_many(:meeting_shifts).through(:section_shifts) }

  it { should have_many(:shift_tag_assignments).through(:section_shifts) }

  it { should have_one(:weekly_shift_duration_rule).dependent(:destroy) }

  it { should have_many(:daily_shift_count_rules).dependent(:destroy) }

  it { should have_one(:section_role_assignment).dependent(:destroy) }

  it { should have_one(:admin_role).through(:section_role_assignment) }

  # validations

  it { should validate_presence_of(:title) }

  it { @section = section; should validate_uniqueness_of(:title) }

  it { should allow_mass_assignment_of(:section_shifts_attributes) }

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
      mock_permission.stub_chain("roles.exists?") { true }
      mock_permission.stub_chain("roles.find_by_name") { mock_admin_role }
      mock_admin_role.stub_chain("role_permissions.first.update_attributes")
      section.create_admin_role.should eq(mock_admin_role)
    end
  end
end
