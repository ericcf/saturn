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

    it "assigns public note details from assignments to @notes" do
      details = mock('note details')
      mock_physician = stub_model(Physician, :short_name => "E. Fudd")
      mock_section.stub_chain("members.includes.hash_by_id").
        and_return({ mock_physician.id => mock_physician })
      assignment = stub_model(Assignment, :public_note_details => details,
        :physician_id => mock_physician.id)
      mock_schedule.stub_chain(:assignments, :includes).and_return([assignment])
      get :show_weekly_section, :section_id => mock_section.id
      assigns(:notes).should eq([details])
    end

    it "assigns weekly schedule presenter to @schedule_presenter" do
      mock_physician = stub_model(Physician, :short_name => "E. Fudd")
      mock_section.stub_chain("members.includes.hash_by_id").
        and_return({ mock_physician.id => mock_physician })
      assignment = stub_model(Assignment, :physician_id => mock_physician.id)
      mock_schedule.stub_chain(:assignments, :includes).and_return([assignment])
      mock_section.stub_chain(:weekly_schedules, :published, :find_by_date)
      mock_section.stub_chain(:weekly_schedules, :build).
        and_return(mock_schedule)
      mock_schedule_presenter = mock("presenter")
      WeeklySchedulePresenter.should_receive(:new).
        with(mock_section, instance_of(Array), [assignment],
             { mock_physician.id => mock_physician },
             { :col_type => :dates, :row_type => :shifts }).
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

  describe "GET edit_weekly_section" do

    def get_edit_default_weekly_section
      date = Date.today
      get :edit_weekly_section, :section_id => mock_section.id,
        :year => date.year, :month => date.month, :day => date.day
    end

    before(:each) do
      @mock_section_shifts = mock("shifts", :active_as_of => nil)
      Section.stub!(:find).
        with(mock_section(:shifts => @mock_section_shifts).id).
        and_return(mock_section)
      WeeklySchedule.stub!(:find) { mock_schedule.as_null_object }
      controller.should_receive(:authenticate_user!)
      controller.stub!(:authorize!).with(:update, mock_section)
    end

    it "assigns Monday before the requested date to first @week_dates" do
      controller.should_receive(:monday_of_week_with) { @monday }
      get :edit_weekly_section, :section_id => mock_section.id,
        :year => @monday.year, :month => @monday.month, :day => @monday.day
      assigns(:week_dates).first.should eq(@monday)
    end

    it "assigns the days of the current week to @week_dates" do
      dates = mock('dates')
      controller.should_receive(:week_dates_beginning_with) { dates }
      get_edit_default_weekly_section
      assigns(:week_dates).should eq(dates)
    end

    it "assigns the requested schedule section to @section" do
      get_edit_default_weekly_section
      assigns(:section).should eq(mock_section)
    end

    it "assigns active section shifts to @shifts" do
      mock_active_shift = mock_model(Shift)
      @mock_section_shifts.should_receive(:active_as_of).with(@monday).
        and_return([mock_active_shift])
      get :edit_weekly_section, :section_id => mock_section.id,
        :year => @monday.year, :month => @monday.month, :day => @monday.day
      assigns(:shifts).should eq([mock_active_shift])
    end

    context "the schedule exists for the specified section and date" do

      it "assigns the schedule to @weekly_schedule" do
        WeeklySchedule.stub!(:find_by_section_id_and_date).
          with(mock_section.id, @monday).
          and_return(mock_schedule)
        get :edit_weekly_section, :section_id => mock_section.id,
          :year => @monday.year, :month => @monday.month, :day => @monday.day
        assigns(:weekly_schedule).should eq(mock_schedule)
      end
    end

    context "the schedule does not exist for the specified section and date" do

      it "assigns a new schedule to @weekly_schedule" do
        WeeklySchedule.stub!(:find_by_section_id_and_date)
        WeeklySchedule.should_receive(:new) { mock_schedule }
        get :edit_weekly_section, :section_id => mock_section.id,
          :year => @monday.year, :month => @monday.month, :day => @monday.day
        assigns(:weekly_schedule).should eq(mock_schedule)
      end
    end

    it "assigns weekly schedule assignments to @assignments" do
      WeeklySchedule.stub!(:find_by_section_id_and_date) { mock_schedule }
      assignment = stub_model(Assignment)
      mock_schedule.should_receive(:assignments) { [assignment] }
      get_edit_default_weekly_section
      assigns(:assignments).should eq([assignment])
    end

    it "assigns grouped section members to @grouped_people" do
      mock_groups = Hash.new
      mock_section.should_receive(:members_by_group) { mock_groups }
      get_edit_default_weekly_section
      assigns(:grouped_people).should eq(mock_groups)
    end

    it "assigns section members by id to @physicians_by_id" do
      mock_physician = stub_model(Physician)
      mock_members = []
      mock_members.stub!(:hash_by_id) {{ mock_physician.id => mock_physician }}
      mock_members.stub!(:includes).with(:names_alias) { mock_members }
      mock_section.stub!(:members) { mock_members }
      get_edit_default_weekly_section
      assigns(:physicians_by_id).
        should eq({ mock_physician.id => mock_physician })
    end

    it "assigns each physician's short_name by physician id to @people_names" do
      mock_physician = stub_model(Physician, :short_name => "Short name")
      mock_members = [mock_physician]
      mock_members.stub!(:hash_by_id)
      mock_members.stub!(:includes).with(:names_alias) { mock_members }
      mock_section.stub!(:members) { mock_members }
      get_edit_default_weekly_section
      assigns(:people_names).
        should eq({ mock_physician.id => mock_physician.short_name })
    end
  end

  describe "POST create_weekly_section" do

    before(:each) do
      Section.stub!(:find).with(mock_section.id) { mock_section }
      controller.should_receive(:authenticate_user!)
      controller.stub!(:authorize!).with(:update, mock_section)
    end

    context "with valid params" do

      before(:each) do
        @date = Date.parse("Monday")
        WeeklySchedule.stub!(:new).
          and_return(mock_schedule(:save => true, :date => @date))
      end

      it "assigns a newly created WeeklySchedule as @weekly_schedule" do
        WeeklySchedule.stub!(:new).
          with({'section_id' => mock_section.id, 'these' => 'params', 'assignments_attributes' => {}}).
          and_return(mock_schedule)
        post :create_weekly_section, :section_id => mock_section.id,
          :weekly_schedule => {:these => 'params'}
        assigns(:weekly_schedule).should eq(mock_schedule)
      end

      it "redirects to the edit path" do
        post :create_weekly_section, :section_id => mock_section.id,
          :weekly_schedule => { :date => @date }
        response.should redirect_to(edit_weekly_section_schedule_path(
          :section_id => mock_section.id, :year => @date.year,
          :month => @date.month, :day => @date.day
        ))
      end

      it "assigns to flash" do
        post :create_weekly_section, :section_id => mock_section.id,
          :weekly_schedule => { :date => @date }
        flash[:notice].should eq("Successfully created schedule")
      end
    end

    context "with invalid params" do

      before(:each) do
        mock_schedule(:save => false,
          :errors => mock("ActiveModel::Errors", :full_messages=>[]))
        WeeklySchedule.stub!(:new) { mock_schedule.as_null_object }
        post :create_weekly_section, :section_id => mock_section.id,
          :weekly_schedule => {:date => Date.today.to_s}
      end

      it "renders the edit template" do
        response.should be_success
        response.should render_template("edit_weekly_section")
      end

      it { flash[:error].should match(/There was an error creating the schedule/) }
    end
  end

  describe "PUT update_weekly_section" do
    
    before(:each) do
      controller.should_receive(:authenticate_user!)
      controller.stub!(:authorize!)
      Section.stub!(:find).with(mock_section.id) { mock_section }
      mock_schedule(:date => Date.today)
      WeeklySchedule.stub!(:find).with(mock_schedule.id) { mock_schedule }
      controller.should_receive(:authorize!).with(:update, mock_section)
    end

    context "with valid params" do

      before(:each) do
        mock_schedule.should_receive(:update_attributes).with(
          :assignments_attributes => [
            { "id" => "1", "_destroy" => "1" },
            { "id" => "2", "these" => "params" }
          ],
          :is_published => 0
        ).and_return(true)
        put :update_weekly_section, :section_id => mock_section.id,
          :weekly_schedule => { :id => mock_schedule.id }, :assignments => [
            { :id => "1", :_destroy => "1" },
            { :id => "2", :these => "params" }
          ]
      end

      it { assigns(:section).should eq(mock_section) }

      it { assigns(:weekly_schedule).should eq(mock_schedule) }

      it do
        should redirect_to(edit_weekly_section_schedule_path(
          :section_id => mock_section.id,
          :year => mock_schedule.date.year,
          :month => mock_schedule.date.month,
          :day => mock_schedule.date.day
        ))
      end

      it { flash[:notice].should eq("Successfully updated schedule.") }
    end

    context "with invalid params" do

      before(:each) do
        mock_schedule.stub!(:update_attributes) { false }
        put :update_weekly_section, :section_id => mock_section.id,
          :weekly_schedule => { :id => mock_schedule.id }
      end

      it "redirects to the edit template for the schedule" do
        response.should redirect_to(edit_weekly_section_schedule_path(
          :section_id => mock_section.id,
          :year => mock_schedule.date.year,
          :month => mock_schedule.date.month,
          :day => mock_schedule.date.day
        ))
      end

      it { flash[:error].should match(/There was an error updating the schedule:/) }
    end
  end
end
