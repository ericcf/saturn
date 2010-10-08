require 'spec_helper'

describe "schedules" do

  include AuthenticationHelpers

  describe "weekly call schedules" do

    context "with no records in the database" do

      it "renders successfully" do
        get weekly_call_schedule_path
        response.should be_success
      end
    end

    context "with a current assignment to a call shift" do

      before(:all) do
        Assignment.delete_all
        Shift.delete_all
        Section.delete_all
        person = Factory(:physician_membership).person
        @assignment = Factory(:assignment, :person => person)
        call_shift_tag = Factory(:shift_tag, :title => "Call")
        Factory(:shift_tag_assignment, :shift => @assignment.shift,
          :shift_tag => call_shift_tag)
      end

      context "with an unpublished weekly schedule" do

        it "does not render the assignment" do
          get weekly_call_schedule_path
          response.should_not contain(@assignment.person.family_name)
        end
      end

      context "with a published weekly schedule" do

        it "renders the assignment" do
          WeeklySchedule.last.update_attribute(:published_at, Date.today)
          get weekly_call_schedule_path
          response.should contain(@assignment.person.family_name)
        end
      end
    end
  end

  context "show a weekly section schedule" do

    context "view_mode == 2 (people on y-axis)" do

      it "renders successfully" do
        Section.delete_all; section = Factory(:section)
        get weekly_section_schedule_path(:section_id => section.id,
          :view_mode => 2)
        response.should be_success
      end
    end
  end

  context "edit a weekly section schedule" do

    context "with no schedules or assignments in the database" do

      it "renders successfully" do
        sign_in_user :admin => true
        Section.delete_all
        section = Factory(:section)
        date = Date.today
        get edit_weekly_section_schedule_path(:section_id => section.id,
          :year => date.year, :month => date.month, :day => date.day)
        response.should be_success
      end
    end
  end
end
