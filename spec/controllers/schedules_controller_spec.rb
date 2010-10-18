require 'spec_helper'

describe SchedulesController do

  def mock_section(stubs={})
    @mock_section ||= mock_model(Section, stubs).as_null_object
  end

  def mock_schedule(stubs={})
    @mock_schedule ||= mock_model(WeeklySchedule, stubs)
  end

  before(:each) do
    @monday = Date.parse("Monday")
  end

  describe "GET weekly_call" do

    before(:each) do
      WeeklySchedule.stub!(:published_with_date).and_return([])
      Section.stub!(:find).with(mock_section.id).and_return(mock_section)
    end

    it "assigns the start of the current week to @start_date" do
      date = Date.parse("Monday")
      controller.should_receive(:monday_of_week_with).and_return(date)
      get :weekly_call
      assigns[:start_date].should == date
    end

    it "assigns the week dates starting on @start_date to @dates" do
      dates = mock('dates')
      controller.should_receive(:week_dates_beginning_with).and_return(dates)
      get :weekly_call
      assigns[:dates].should == dates
    end

    it "assigns published weekly schedules from @start_date to @schedules" do
      date = Date.today.at_beginning_of_week
      WeeklySchedule.stub_chain(:published, :find_all_by_date).
        and_return([mock_schedule])
      get :weekly_call, :date => date
      assigns(:schedules).should == [mock_schedule]
    end

    it "assigns all call shifts to @call_shifts" do
      mock_shift = mock_model(Shift)
      Shift.stub_chain(:includes, :where).and_return([mock_shift])
      get :weekly_call
      assigns(:call_shifts).should == [mock_shift]
    end

    it "assigns ordered assignments this week to @call_assignments" do
      date = Date.today
      WeeklySchedule.delete_all; Shift.delete_all
      mock_assignment = stub_model(Assignment)
      Assignment.stub!(:by_schedules_and_shifts).and_return([mock_assignment])
      mock_physician = stub_model(Physician)
      Physician.stub_chain(:where, :includes, :hash_by_id).
        and_return({ mock_physician.id => mock_physician })
      get :weekly_call, :date => date
      assigns[:call_assignments].should == [mock_assignment]
    end

    it "assigns public note details from assignments to @notes" do
      details = mock('note details')
      mock_assignment = stub_model(Assignment, :public_note_details => details)
      Assignment.stub!(:by_schedules_and_shifts).and_return([mock_assignment])
      mock_physician = stub_model(Physician)
      Physician.stub_chain(:where, :includes, :hash_by_id).
        and_return({ mock_physician.id => mock_physician })
      get :weekly_call
      assigns(:notes).should == [details]
    end
  end

  describe "GET show_weekly_section" do

    before(:each) do
      Section.stub!(:find).with(mock_section.id).and_return(mock_section)
      mock_schedule.stub_chain(:assignments, :includes).and_return([])
      mock_section.stub_chain(:weekly_schedules, :published, :find_by_date).
        and_return(mock_schedule)
    end

    it "assigns the requested schedule section to @section" do
      get :show_weekly_section, :section_id => mock_section.id
      assigns[:section].should == mock_section
    end

    it "assigns the week dates starting on @week_start_date to @week_dates" do
      dates = [mock('date')]
      controller.should_receive(:week_dates_beginning_with).and_return(dates)
      get :show_weekly_section, :section_id => mock_section.id
      assigns(:dates).should eq(dates)
    end

    it "assigns public note details from assignments to @notes" do
      details = mock('note details')
      mock_physician = stub_model(Physician, :short_name => "E. Fudd")
      Physician.stub_chain(:with_assignments, :includes, :hash_by_id).
        and_return({ mock_physician.id => mock_physician })
      assignment = stub_model(Assignment, :public_note_details => details,
        :physician_id => mock_physician.id)
      mock_schedule.stub_chain(:assignments, :includes).and_return([assignment])
      get :show_weekly_section, :section_id => mock_section.id
      assigns(:notes).should == [details]
    end

    it "assigns weekly schedule presenter to @schedule_presenter" do
      mock_physician = stub_model(Physician, :short_name => "E. Fudd")
      Physician.stub_chain(:with_assignments, :includes, :hash_by_id).
        and_return({ mock_physician.id => mock_physician })
      assignment = stub_model(Assignment, :physician_id => mock_physician.id)
      mock_schedule.stub_chain(:assignments, :includes).and_return([assignment])
      mock_section.stub_chain(:weekly_schedules, :published, :find_by_date)
      mock_section.stub_chain(:weekly_schedules, :build).
        and_return(mock_schedule)
      mock_schedule_presenter = mock("presenter")
      WeeklySchedulePresenter.should_receive(:new).
        with(mock_section, anything, [assignment], { :col_type => :dates, :row_type => :shifts }).
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

    before(:each) do
      @mock_section_shifts = mock("shifts", :active_as_of => nil)
      Section.stub!(:find).
        with(mock_section(:shifts => @mock_section_shifts).id).
        and_return(mock_section)
      WeeklySchedule.stub!(:find).and_return(mock_schedule.as_null_object)
      controller.should_receive(:authenticate_user!)
      controller.stub!(:authorize!)
    end

    it "assigns Monday before the requested date to @week_start_date" do
      controller.should_receive(:monday_of_week_with).and_return(@monday)
      get :edit_weekly_section, :section_id => mock_section.id,
        :year => @monday.year, :month => @monday.month, :day => @monday.day
      assigns[:week_start_date].should == @monday
    end

    it "assigns the days of the current week to @week_dates" do
      dates = mock('dates')
      controller.should_receive(:week_dates_beginning_with).and_return(dates)
      get :edit_weekly_section, :section_id => mock_section.id, :year => 2010,
        :month => 1, :day => 1
      assigns[:week_dates].should == dates
    end

    it "assigns the requested schedule section to @section" do
      get :edit_weekly_section, :section_id => mock_section.id, :year => 2010,
        :month => 1, :day => 1
      assigns[:section].should == mock_section
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
        controller.should_receive(:authorize!).with(:manage, mock_schedule)
        get :edit_weekly_section, :section_id => mock_section.id,
          :year => @monday.year, :month => @monday.month, :day => @monday.day
        assigns[:weekly_schedule].should == mock_schedule
      end
    end

    context "the schedule does not exist for the specified section and date" do

      it "assigns a new schedule to @weekly_schedule" do
        WeeklySchedule.stub!(:find_by_section_id_and_date)
        WeeklySchedule.should_receive(:new).and_return(mock_schedule)
        controller.should_receive(:authorize!).with(:manage, mock_schedule)
        get :edit_weekly_section, :section_id => mock_section.id,
          :year => @monday.year, :month => @monday.month, :day => @monday.day
        assigns[:weekly_schedule].should == mock_schedule
      end
    end

    it "assigns weekly schedule assignments to @assignments" do
      WeeklySchedule.stub!(:find_by_section_id_and_date).
        and_return(mock_schedule)
      assignment = stub_model(Assignment)
      mock_schedule.should_receive(:assignments).and_return([assignment])
      get :edit_weekly_section, :section_id => mock_section.id, :year => 2010,
        :month => 1, :day => 1
      assigns[:assignments].should == [assignment]
    end

    it "assigns grouped section members to @grouped_people" do
      mock_groups = Array.new
      mock_section.should_receive(:members_by_group).and_return(mock_groups)
      get :edit_weekly_section, :section_id => mock_section.id, :year => 2010,
        :month => 1, :day => 1
      assigns[:grouped_people].should == mock_groups
    end
  end

  describe "POST create_weekly_section" do

    before(:each) do
      Section.stub!(:find).with(mock_section.id).and_return(mock_section)
      controller.should_receive(:authenticate_user!)
      controller.stub!(:authorize!)
    end

    context "with valid params" do

      it "assigns a newly created WeeklySchedule as @weekly_schedule" do
        WeeklySchedule.should_receive(:new).
          with({'section_id' => mock_section.id, 'these' => 'params', 'assignments_attributes' => {}}).
          and_return(mock_schedule(:save => true, :date => Date.today))
        controller.should_receive(:authorize!).with(:manage, mock_schedule)
        post :create_weekly_section, :section_id => mock_section.id,
          :weekly_schedule => {:these => 'params'}
        assigns[:weekly_schedule].should ==  mock_schedule
      end

      it "redirects to the edit path" do
        date = Date.parse("Monday")
        WeeklySchedule.stub!(:new).
          and_return(mock_schedule(:save => true, :date => date))
        post :create_weekly_section, :section_id => mock_section.id,
          :weekly_schedule => {:date => date}
        response.should redirect_to(edit_weekly_section_schedule_path(
          :section_id => mock_section.id, :year => date.year,
          :month => date.month, :day => date.day
        ))
      end
    end

    context "with invalid params" do

      before(:each) do
        mock_schedule(:save => false,
          :errors => mock("ActiveModel::Errors", :full_messages=>[]))
        WeeklySchedule.stub!(:new).and_return(mock_schedule.as_null_object)
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
      Section.stub!(:find).with(mock_section.id).and_return(mock_section)
      mock_schedule(:date => Date.today)
      WeeklySchedule.stub!(:find).with(mock_schedule.id).
        and_return(mock_schedule)
      controller.should_receive(:authorize!).with(:update, mock_schedule)
    end

    context "with valid params" do

      before(:each) do
        mock_schedule.should_receive(:update_attributes).with(
          :assignments_attributes => [
            { "id" => "1", "_destroy" => "1" },
            { "id" => "2", "these" => "params" }
          ]
        ).and_return(true)
        put :update_weekly_section, :section_id => mock_section.id,
          :weekly_schedule => { :id => mock_schedule.id }, :assignments => [
            { :id => "1", :_destroy => "1" },
            { :id => "2", :these => "params" }
          ]
      end

      it { assigns[:section].should eq(mock_section) }

      it { assigns[:weekly_schedule].should eq(mock_schedule) }

      it do
        should redirect_to(edit_weekly_section_schedule_path(
          :section_id => mock_section.id,
          :year => mock_schedule.date.year,
          :month => mock_schedule.date.month,
          :day => mock_schedule.date.day
        ))
      end

      it { flash[:notice].should == "Successfully updated schedule." }
    end

    context "with invalid params" do

      before(:each) do
        mock_schedule.stub!(:update_attributes).and_return(false)
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
