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

    it "assigns call schedule presenter to @schedule_presenter" do
      mock_presenter = stub(::Logical::CallSchedulePresenter)
      ::Logical::CallSchedulePresenter.stub!(:new) { mock_presenter }
      get :weekly_call
      assigns(:schedule_presenter).should eq(mock_presenter)
    end
  end

  describe "GET show_weekly_section" do

    before(:each) do
      Section.stub!(:find).with(mock_section.id.to_s) { mock_section }
      mock_schedule.stub_chain(:assignments, :includes) { [] }
      mock_section.stub_chain("weekly_schedules.published.find_by_date").
        and_return(mock_schedule)
    end

    it "assigns the requested schedule section to @section" do
      get :show_weekly_section, :section_id => mock_section.id
      assigns(:section).should eq(mock_section)
    end

    it "assigns weekly assignments to @assignments" do
      ::Logical::WeeklySchedulePresenter.stub!(:new)
      mock_assignment = stub_model(Assignment)
      mock_schedule.stub!(:assignments).
        and_return([mock_assignment])
      get :show_weekly_section, :section_id => mock_section.id
      assigns(:assignments).should eq([mock_assignment])
    end

    it "assigns weekly schedule presenter to @schedule_presenter" do
      mock_physician = stub_model(Physician, :short_name => "E. Fudd")
      mock_section.stub!(:members) { [mock_physician] }
      assignment = stub_model(Assignment, :physician_id => mock_physician.id)
      mock_schedule.stub_chain(:assignments).and_return([assignment])
      mock_section.stub_chain(:weekly_schedules, :published, :find_by_date)
      mock_section.stub_chain(:weekly_schedules, :build).
        and_return(mock_schedule)
      mock_schedule_presenter = mock("presenter")
      ::Logical::WeeklySchedulePresenter.should_receive(:new).
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
          should be_an_instance_of(::Logical::WeeklySchedulePresenter)
      end
    end
  end
end
