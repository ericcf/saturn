require 'spec_helper'

describe WeeklySchedulesController do

  let(:mock_schedule) { mock_model(WeeklySchedule, :to_json => "json!") }
  let(:mock_section) do
    mock_model(Section, :weekly_schedules => [mock_schedule])
  end
  let(:monday) { Date.today.at_beginning_of_week }

  before(:each) do
    Section.stub!(:find).with(mock_section.id) { mock_section }
  end

  describe "GET show" do

    before(:each) do
      get :show, :section_id => mock_section.id
    end

    it { assigns(:weekly_schedules).should eq([mock_schedule]) }
  end

  describe "GET edit" do

    before(:each) do
      controller.should_receive(:authenticate_user!)
      controller.should_receive(:authorize!).with(:update, mock_section)
    end

    context "a schedule exists for the section and date" do

      before(:each) do
        WeeklySchedule.stub!(:find_by_section_id_and_date).
          with(mock_section.id, monday).
          and_return(mock_schedule)
        get :edit, :section_id => mock_section.id, :date => monday,
          :format => :json
      end

      it "assigns the schedule to @weekly_schedule" do
        assigns(:weekly_schedule).should eq(mock_schedule)
      end

      it "renders the schedule as json" do
        response.body.should eq(mock_schedule.to_json)
      end
    end
  end

  describe "POST create" do

    before(:each) do
      controller.should_receive(:authenticate_user!)
      controller.should_receive(:authorize!).with(:update, mock_section)
    end

    context "no schedule exists for the section and date" do

      before(:each) do
        WeeklySchedule.stub!(:find_by_section_id_and_date)
        WeeklySchedule.stub!(:create).
          with(:section_id => mock_section.id, :date => monday).
          and_return(mock_schedule)
        mock_schedule.stub!(:update_attributes)
        mock_schedule.stub!(:touch)
        WeeklySchedule.stub!(:find).with(mock_schedule.id) { mock_schedule }
        post :create,
          :section_id => mock_section.id,
          :weekly_schedule => {
            :date => monday
          }.to_json,
          :format => :json
      end

      it "assigns a newly created schedule to @weekly_schedule" do
        assigns(:weekly_schedule).should eq(mock_schedule)
      end
    end
  end
end
