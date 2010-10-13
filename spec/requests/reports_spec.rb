require 'spec_helper'

describe "reports" do

  context "shift totals for a section" do

    it "is successful" do
      faculty = RadDirectory::Group.find_or_create_by_title("Faculty")
      physician = Factory(:physician)
      RadDirectory::Membership.create(:contact => physician, :group => faculty)
      section = Factory(:section)
      shift_tag = Factory(:shift_tag, :section => section)
      shift = Factory(:shift_tag_assignment, :shift_tag => shift_tag).shift
      SectionMembership.create(:physician => physician,
        :section => section)
      schedule = Factory(:weekly_schedule, :published_at => Date.today)
      assignment = Factory(:assignment, :physician => physician,
        :shift => shift, :weekly_schedule => schedule)
      get section_shift_totals_path(section)
      response.should be_success
    end
  end
end
