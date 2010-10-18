require 'spec_helper'

describe PhysiciansController do

  def mock_physician(stubs={})
    @mock_physician ||= mock_model(Physician, stubs).as_null_object
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
        @mock_shift = stub_model(Shift)
        @mock_assignment = stub_model(Assignment, :shift => @mock_shift,
          :physician_id => 666)
        Assignment.stub_chain(:published, :where, :includes).
          and_return([@mock_assignment])
        get :search, :query => "Boo"
      end

      it { assigns(:physicians).should eq([mock_physician]) }

      it { assigns(:query).should eq("Boo") }

      it do
        assigns(:shifts_by_physician).should == {
          @mock_assignment.physician_id => [@mock_shift]
        }
      end
    end
  end

  describe "GET schedule" do

    context "the requested physician is found" do

      before(:each) do
        Physician.should_receive(:find).with(mock_physician.id).
          and_return(mock_physician)
      end

      context "any format" do

        before(:each) do
          get :schedule, :id => mock_physician.id
        end

        it { assigns(:physician).should == mock_physician }

        it { assigns(:dates).should include(Date.today) }
      end

      context "the format is ics" do

        before(:each) do
          get :schedule, :id => mock_physician.id, :format => "ics"
        end

        it { response.content_type.should == "text/calendar" }
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
