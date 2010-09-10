require 'spec_helper'

describe "weekly call schedules" do

  context "with no records in the database" do

    it "renders successfully" do
      get weekly_call_schedule_path
      response.should be_success
    end
  end
end

describe "daily duty schedule" do

  context "with no records in the database" do

    it "renders successfully" do
      get daily_duty_schedule_path
      response.should be_success
    end
  end

  context "with a section in the database" do

    before(:all) { @section = Factory(:section) }

    it "renders successfully" do
      get daily_duty_schedule_path
      response.should be_success
    end

    context "with a person in the section" do

      before(:all) do
        @person = Factory(:person)
        @person.sections << @section
      end

      it "renders successfully" do
        get daily_duty_schedule_path
        response.should be_success
      end
    end
  end
end

context "edit a weekly schedule" do

  context "with no schedules or assignments in the database" do

    it "renders successfully" do
      section = Factory(:section)
      date = Date.today
      get edit_weekly_section_schedule_path(:section_id => section.id,
        :year => date.year, :month => date.month, :day => date.day)
      response.should be_success
    end
  end
end
