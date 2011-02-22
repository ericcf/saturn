require 'spec_helper'

describe SchedulesController do

  def mock_section(stubs={})
    (@mock_section ||= mock_model(Section).as_null_object).tap do |section|
      section.stub(stubs) unless stubs.empty?
    end
  end

  def mock_schedule(stubs={})
    (@mock_schedule ||= mock_model(WeeklySchedule).as_null_object).tap do |schedule|
      schedule.stub(stubs) unless stubs.empty?
    end
  end

  before(:each) do
    @monday = Date.parse("Monday")
  end

  describe "GET weekly_call" do

    before(:each) do
      Section.stub!(:find).with(mock_section.id) { mock_section }
    end

    it "assigns the week dates starting on Monday to @dates" do
      dates = []
      controller.should_receive(:week_dates_beginning_with) { dates }
      get :weekly_call
      assigns(:dates).should eq(dates)
    end

    it "assigns all call shifts to @call_shifts" do
      mock_shift = mock_model(Shift)
      Shift.stub_chain(:includes, :where) { [mock_shift] }
      get :weekly_call
      assigns(:call_shifts).should eq([mock_shift])
    end

    it "assigns ordered assignments this week to @call_assignments" do
      date = Date.today
      WeeklySchedule.delete_all; Shift.delete_all
      mock_assignment = stub_model(Assignment)
      Assignment.stub!(:by_schedules_and_shifts) { [mock_assignment] }
      mock_physician = stub_model(Physician)
      Physician.stub_chain(:where, :includes, :hash_by_id).
        and_return({ mock_physician.id => mock_physician })
      get :weekly_call, :date => { :year => date.year, :month => date.month, :day => date.day }
      assigns(:call_assignments).should eq([mock_assignment])
    end

    it "assigns public note details from assignments to @notes" do
      details = mock('note details')
      mock_assignment = stub_model(Assignment, :public_note_details => details)
      Assignment.stub!(:by_schedules_and_shifts) { [mock_assignment] }
      mock_physician = stub_model(Physician)
      Physician.stub_chain(:where, :includes, :hash_by_id).
        and_return({ mock_physician.id => mock_physician })
      get :weekly_call
      assigns(:notes).should eq([details])
    end
  end

  describe "GET show_weekly_section" do

    before(:each) do
      Section.stub!(:find).with(mock_section.id) { mock_section }
      mock_schedule.stub_chain(:assignments, :includes) { [] }
      mock_section.stub_chain("weekly_schedules.find_by_is_published_and_date").
        and_return(mock_schedule)
    end

    it "assigns the week dates starting on @week_start_date to @dates" do
      dates = [mock('date')]
      controller.should_receive(:week_dates_beginning_with) { dates }
      get :show_weekly_section, :section_id => mock_section.id
      assigns(:dates).should eq(dates)
    end

    it "assigns the requested schedule section to @section" do
      get :show_weekly_section, :section_id => mock_section.id
      assigns(:section).should eq(mock_section)
    end

    it "assigns weekly assignments to @assignments" do
      WeeklySchedulePresenter.stub!(:new)
      mock_assignment = stub_model(Assignment)
      mock_schedule.stub_chain(:assignments, :includes).
        and_return([mock_assignment])
      get :show_weekly_section, :section_id => mock_section.id
      assigns(:assignments).should eq([mock_assignment])
    end

    it "assigns weekly schedule presenter to @schedule_presenter" do
      mock_physician = stub_model(Physician, :short_name => "E. Fudd")
      mock_section.stub_chain("members.includes.each_with_object").
        and_return({ mock_physician.id => mock_physician.short_name })
      assignment = stub_model(Assignment, :physician_id => mock_physician.id)
      mock_schedule.stub_chain(:assignments, :includes).and_return([assignment])
      mock_section.stub_chain(:weekly_schedules, :published, :find_by_date)
      mock_section.stub_chain(:weekly_schedules, :build).
        and_return(mock_schedule)
      mock_schedule_presenter = mock("presenter")
      WeeklySchedulePresenter.should_receive(:new).
        with(:section => mock_section, :dates => instance_of(Array),
             :assignments => [assignment], :weekly_schedule => mock_schedule,
             :physician_names_by_id => { mock_physician.id => mock_physician.short_name },
             :options => { :col_type => :dates, :row_type => :shifts }).
        and_return(mock_schedule_presenter)
      get :show_weekly_section, :section_id => mock_section.id
      assigns(:schedule_presenter).should eq(mock_schedule_presenter)
    end

    context "view_mode = 2 (people on y-axis)" do

      it "assigns tabular data object to @schedule_view" do
        get :show_weekly_section, :section_id => mock_section.id, :view_mode => 2
        assigns(:schedule_presenter).
          should be_an_instance_of(WeeklySchedulePresenter)
      end
    end
  end
end
