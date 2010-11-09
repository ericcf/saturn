require 'spec_helper'

describe "schedules" do

  include AuthenticationHelpers

  def clean_up_database
    [Assignment, Shift, SectionMembership, Section, WeeklySchedule].each do |klass|
      klass.delete_all
    end
  end

  describe "weekly call schedules" do

    context "with no records in the database" do

      before(:each) { clean_up_database }

      it "renders successfully" do
        get weekly_call_schedule_path
        response.should be_success
      end
    end

    context "with a current assignment to a call shift" do

      before(:all) do
        clean_up_database
        physician = Factory(:physician)
        @assignment = Factory(:assignment, :physician => physician)
        call_shift_tag = Factory(:shift_tag, :title => "Call")
        Factory(:shift_tag_assignment, :shift => @assignment.shift,
          :shift_tag => call_shift_tag)
      end

      context "with an unpublished weekly schedule" do

        it "does not render the assignment" do
          get weekly_call_schedule_path
          response.should_not contain(@assignment.physician.family_name)
        end
      end

      context "with a published weekly schedule" do

        before(:all) do
          WeeklySchedule.last.update_attribute(:published_at, Date.today)
        end

        it "renders the assignment" do
          get weekly_call_schedule_path
          response.should contain(@assignment.physician.family_name)
        end
      end
    end
  end

  context "show a weekly section schedule" do

    before(:each) { clean_up_database }

    context "view_mode == 2 (people on y-axis)" do

      before(:each) do
        @physician = Factory(:physician)
        @section = Factory(:section)
        SectionMembership.create(:physician => @physician, :section => @section)
        Factory(:assignment, :physician => @physician)
      end

      it "renders physician names in the left column" do
        get weekly_section_schedule_path(:section_id => @section.id,
          :view_mode => 2)
        response.should have_selector("tbody tr th a", :content => @physician.short_name)
      end

      context "in xls format" do

        it "renders a spreadsheet" do
          get weekly_section_schedule_path(:section_id => @section.id,
            :format => :xls)
          response.headers["Content-Type"].should =~ /#{Mime::XLS}/
        end
      end
    end
  end

  context "edit a weekly section schedule" do

    before(:each) { clean_up_database }

    context "with no schedules or assignments in the database" do

      it "renders successfully" do
        sign_in_user :admin => true
        section = Factory(:section)
        date = Date.today
        get edit_weekly_section_schedule_path(:section_id => section.id,
          :year => date.year, :month => date.month, :day => date.day)
        response.should be_success
      end
    end
  end

  context "update an existing weekly section schedule" do

    before(:each) { clean_up_database }

    context "publish checkbox is checked" do

      it "publishes the schedule" do
        sign_in_user :admin => true
        schedule = Factory(:weekly_schedule)
        date = Date.today
        put update_weekly_section_schedule_path(:section_id => schedule.section_id,
          :weekly_schedule => { :id => schedule.id, :publish => "1" })
        response.should redirect_to(edit_weekly_section_schedule_path(
          :section_id => schedule.section_id, :year => schedule.date.year,
          :month => schedule.date.month, :day => schedule.date.day
        ))
        WeeklySchedule.find(schedule.id).published?.should be_true
      end
    end

    context "publish checkbox is unchecked" do

      it "unpublishes the schedule" do
        sign_in_user :admin => true
        schedule = Factory(:published_weekly_schedule)
        date = Date.today
        put update_weekly_section_schedule_path(:section_id => schedule.section_id,
          :weekly_schedule => { :id => schedule.id, :publish => "0" })
        response.should redirect_to(edit_weekly_section_schedule_path(
          :section_id => schedule.section_id, :year => schedule.date.year,
          :month => schedule.date.month, :day => schedule.date.day
        ))
        WeeklySchedule.find(schedule.id).published?.should be_false
      end
    end
  end
end
