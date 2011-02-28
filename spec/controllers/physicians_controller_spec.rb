require 'spec_helper'

describe PhysiciansController do

  def mock_physician(stubs={})
    (@mock_physician ||= stub_model(Physician)).tap do |physician|
      physician.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET 'index'" do

    before(:each) do
      Physician.stub_chain(:section_members, :includes).
        and_return([mock_physician])
      get :index
    end

    it { assigns(:physicians).should eq([mock_physician]) }
  end

  describe "GET search" do

    context "no query parameter" do

      before(:each) do
        get :search
      end

      it { should render_template(:search) }
    end

    context "query parameter present" do

      before(:each) do
        Physician.stub_chain(:section_members, :name_like).
          and_return([mock_physician])
        mock_shift = stub_model(Shift)
        @mock_assignment = stub_model(Assignment, :shift => mock_shift,
          :physician_id => mock_physician.id)
        mock_schedule = stub_model(WeeklySchedule, :dates => [Date.today])
        WeeklySchedule.stub_chain("published.include_dates") { [mock_schedule] }
        Assignment.stub!(:where).
          with(:physician_id => [mock_physician.id], :date => [Date.today]).
          and_return([@mock_assignment])
        get :search, :query => "Boo"
      end

      it { assigns(:query).should eq("Boo") }

      it { assigns(:physicians).should eq([mock_physician]) }

      it { assigns(:dates).should eq((Date.today..Date.today+6.days).entries) }

      it { assigns(:assignments).should eq([@mock_assignment]) }
    end
  end

  describe "GET schedule" do

    context "the requested physician is found" do

      before(:each) do
        Physician.should_receive(:find).with(mock_physician.id).
          and_return(mock_physician)
        @mock_schedule = stub_model(PhysicianSchedule)
        PhysicianSchedule.should_receive(:new).with(
          :physician => mock_physician,
          :start_date => Date.today.at_beginning_of_week,
          :number_of_days => 28
        ).and_return(@mock_schedule)
      end

      context "any format" do

        before(:each) do
          get :schedule, :id => mock_physician.id
        end

        it { assigns(:physician).should == mock_physician }

        it { assigns(:schedule).should == @mock_schedule }
      end

      context "the format is ics" do

        before(:each) do
          get :schedule, :id => mock_physician.id, :format => "ics"
        end

        it { response.content_type.should == Mime::ICS }
      end
    end

    context "the requested physician is not found" do

      before(:each) do
        Physician.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        get :schedule, :id => 1
      end

      it { flash[:error].should == "Error: requested physician not found" }

      it { should redirect_to(physicians_path) }
    end
  end
end
