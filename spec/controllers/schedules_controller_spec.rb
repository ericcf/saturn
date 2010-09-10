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
      Shift.should_receive(:by_tag).with("Call").and_return([mock_shift])
      get :weekly_call
      assigns(:call_shifts).should == [mock_shift]
    end

    it "assigns ordered assignments this week to @call_assignments" do
      date = Date.today
      mock_assignment = stub_model(Assignment)
      assignments = stub('assignments')
      assignments.should_receive(:find).
        with(:all, :order => :position, :include => :person).
        and_return([mock_assignment])
      Assignment.should_receive(:by_schedules_and_shifts).with([], []).
        and_return(assignments)
      get :weekly_call, :date => date
      assigns[:call_assignments].should == [mock_assignment]
    end

    it "assigns public note details from assignments to @notes" do
      details = mock('note details')
      mock_assignment = mock_model(Assignment, :public_note_details => details)
      Assignment.stub_chain(:by_schedules_and_shifts, :find).
        and_return([mock_assignment])
      get :weekly_call
      assigns(:notes).should == [details]
    end
  end

  describe "GET daily_duty_roster" do

    context "there is a :date parameter" do

      it "assigns the requested date to @date" do
        get :daily_duty_roster, :date => "2010-01-01"
        assigns[:date].should == Date.parse("2010-01-01")
      end
    end

    context "there is not a :date paramter" do

      it "assigns the current date to @date" do
        get :daily_duty_roster
        assigns(:date).should == Date.today
      end
    end

    it "assigns all schedule sections to @sections" do
      Section.should_receive(:all).and_return([mock_section])
      get :daily_duty_roster
      assigns[:sections].should == [mock_section]
    end

    it "assigns all clinical shifts to @clinical_shifts" do
      mock_shift = mock_model(Shift)
      Shift.should_receive(:by_tag).with("Clinical").and_return([mock_shift])
      get :daily_duty_roster
      assigns(:clinical_shifts).should == [mock_shift]
    end

    it "assigns published schedules covering the date to @weekly_schedules" do
      WeeklySchedule.stub_chain(:published, :find_all_by_date).
        and_return([mock_schedule])
      get :daily_duty_roster
      assigns(:weekly_schedules).should == [mock_schedule]
    end

    it "assigns ordered assignments today to @clinical_assignments" do
      date = Date.today
      mock_assignment = stub_model(Assignment)
      assignments = stub('assignments')
      assignments.should_receive(:find_all_by_date).
        with(date, :order => :position, :include => [:person, :shift]).
        and_return([mock_assignment])
      Assignment.should_receive(:by_schedules_and_shifts).with([], []).
        and_return(assignments)
      get :daily_duty_roster, :date => date
      assigns[:clinical_assignments].should == [mock_assignment]
    end

    it "assigns public note details from assignments to @notes" do
      details = mock('note details')
      assignment = mock_model(Assignment, :public_note_details => details)
      assignments = stub('assignments', :find_all_by_date => [assignment])
      Assignment.stub!(:by_schedules_and_shifts).and_return(assignments)
      get :daily_duty_roster
      assigns[:notes].should == [details]
    end
  end

  describe "GET show_weekly_section" do

    before(:each) do
      Section.stub!(:find).with(mock_section.id).and_return(mock_section)
    end

    it "assigns the requested schedule section to @section" do
      get :show_weekly_section, :section_id => mock_section.id
      assigns[:section].should == mock_section
    end

    it "assigns the week dates starting on @week_start_date to @week_dates" do
      dates = mock('dates')
      controller.should_receive(:week_dates_beginning_with).and_return(dates)
      get :show_weekly_section, :section_id => mock_section.id
      assigns(:dates).should == dates
    end

    describe "assignment of @weekly_schedule" do

      before(:each) do
        @date = Date.today.at_beginning_of_week
      end

      context "the corresponding weekly schedule is published" do

        it "assigns the weekly schedule to @weekly_schedule" do
          published_schedules = mock('published schedules',
            :find_by_date => mock_schedule.as_null_object)
          schedules = mock('schedules', :published => published_schedules)
          mock_section.stub!(:weekly_schedules).and_return(schedules)
          get :show_weekly_section, :date => @date, :section_id => mock_section.id
          assigns(:schedule).should == mock_schedule
        end
      end

      context "the corresponding weekly schedule is not published" do

        it "assigns a new weekly schedule to @schedule" do
          published_schedules = mock('published schedules', :find_by_date => nil)
          schedules = mock('schedules', :published => published_schedules)
          mock_section.stub!(:weekly_schedules).and_return(schedules)
          new_schedule = mock_model(WeeklySchedule).as_null_object
          WeeklySchedule.should_receive(:new).
            with(:section_id => mock_section.id, :date => @date).
            and_return(new_schedule)
          get :show_weekly_section, :date => @date, :section_id => mock_section.id
          assigns(:schedule).should == new_schedule
        end
      end
    end

    it "assigns weekly schedule assignments to @assignments" do
      assignment = stub_model(Assignment)
      Assignment.should_receive(:find_all_by_weekly_schedule_id).
        with(mock_schedule.id, :include => [{:person=>:names_alias}, :shift]).
        and_return([assignment])
      WeeklySchedule.stub!(:new).and_return(mock_schedule)
      mock_section.stub_chain(:weekly_schedules, :published, :find_by_date)
      get :show_weekly_section, :section_id => mock_section.id
      assigns(:assignments).should == [assignment]
    end

    it "assigns public note details from assignments to @notes" do
      details = mock('note details')
      assignment = stub_model(Assignment, :public_note_details => details)
      Assignment.stub!(:find_all_by_weekly_schedule_id).and_return([assignment])
      mock_section.stub_chain(:weekly_schedules, :published, :find_by_date)
      get :show_weekly_section, :section_id => mock_section.id
      assigns(:notes).should == [details]
    end
  end

  describe "GET edit_weekly_section" do

    before(:each) do
      @mock_section_shifts = mock("shifts", :active_as_of => nil)
      Section.stub!(:find).
        with(mock_section(:shifts => @mock_section_shifts).id).
        and_return(mock_section)
      WeeklySchedule.stub!(:find).and_return(mock_schedule.as_null_object)
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
        get :edit_weekly_section, :section_id => mock_section.id,
          :year => @monday.year, :month => @monday.month, :day => @monday.day
        assigns[:weekly_schedule].should == mock_schedule
      end
    end

    context "the schedule does not exist for the specified section and date" do

      it "assigns a new schedule to @weekly_schedule" do
        WeeklySchedule.stub!(:find_by_section_id_and_date)
        WeeklySchedule.should_receive(:new).and_return(mock_schedule)
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
    end

    context "with valid params" do

      it "assigns a newly created WeeklySchedule as @weekly_schedule" do
        WeeklySchedule.should_receive(:new).
          with({'section_id' => mock_section.id, 'these' => 'params', 'assignments_attributes' => {}}).
          and_return(mock_schedule(:save => true, :date => Date.today))
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
        WeeklySchedule.stub!(:new).
          and_return(mock_schedule.as_null_object)
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

    context "with valid params" do

      before(:each) do
        Section.stub!(:find).with(mock_section.id).and_return(mock_section)
        mock_schedule(:update_attributes => true, :date => Date.today)
        WeeklySchedule.stub!(:find).with(mock_schedule.id).
          and_return(mock_schedule.as_null_object)
      end

      it "assigns the requested schedule section to @section" do
        put :update_weekly_section, :section_id => mock_section.id,
          :weekly_schedule => { :id => mock_schedule.id }
        assigns[:section].should == mock_section
      end

      it "updates the weekly schedule and its associated assignments" do
        mock_schedule.should_receive(:update_attributes).with(
          :assignments_attributes => [
            { "id" => "1", "_destroy" => "1" },
            { "id" => "2", "these" => "params" }
          ]
        )
        put :update_weekly_section, :section_id => mock_section.id,
          :weekly_schedule => { :id => mock_schedule.id }, :assignments => [
            { :id => "1", :_destroy => "1" },
            { :id => "2", :these => "params" }
          ]
      end

      it "assigns the updated weekly schedule to @weekly_schedule" do
        put :update_weekly_section, :section_id => mock_section.id,
          :weekly_schedule => { :id => mock_schedule.id }
        assigns[:weekly_schedule].should == mock_schedule
      end

      it "redirects to the updated schedule" do
        put :update_weekly_section, :section_id => mock_section.id,
          :weekly_schedule => { :id => mock_schedule.id }
        response.should redirect_to(edit_weekly_section_schedule_path(
          :section_id => mock_section.id,
          :year => mock_schedule.date.year,
          :month => mock_schedule.date.month,
          :day => mock_schedule.date.day
        ))
      end
    end
  end
end
