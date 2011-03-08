require 'spec_helper'

describe WeeklySchedulesController do

  let(:mock_schedule) { mock_model(WeeklySchedule) }
  let(:mock_section) do
    mock_model(Section, :weekly_schedules => [mock_schedule])
  end

  before(:each) do
    Section.stub!(:find).with(mock_section.id) { mock_section }
  end

  describe "GET show" do

    before(:each) do
      get :show, :section_id => mock_section.id
    end

    it { assigns(:weekly_schedules).should eq([mock_schedule]) }
  end
end
