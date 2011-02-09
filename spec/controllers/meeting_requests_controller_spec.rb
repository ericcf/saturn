require 'spec_helper'

describe MeetingRequestsController do

  def mock_request(stubs={})
    (@mock_request ||= mock_model(MeetingRequest).as_null_object).tap do |v_request|
      v_request.stub(stubs) unless stubs.empty?
    end
  end

  before(:each) do
    @mock_section = mock_model(Section, :meeting_requests => [])
    Section.stub!(:find).with(@mock_section.id).and_return(@mock_section)
  end

  describe "GET index" do

    before(:each) do
      @mock_section.stub!(:meeting_requests).and_return([mock_request])
      get :index, :section_id => @mock_section.id
    end
    
    it { assigns(:meeting_requests).should eq([mock_request]) }
  end

  describe "GET show" do

    before(:each) do
      @mock_requests = mock("meeting_requests")
      @mock_section.stub!(:meeting_requests).and_return(@mock_requests)
    end

    context "the requested meeting_request is found" do

      before(:each) do
        @mock_requests.should_receive(:find).with(mock_request.id).
          and_return(mock_request)
        get :show, :section_id => @mock_section.id,
          :id => mock_request.id
      end

      it { assigns(:meeting_request).should eq(mock_request) }
    end

    context "the requested meeting_request is not found" do

      before(:each) do
        @mock_requests.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        get :show, :section_id => @mock_section.id, :id => 1
      end

      it { flash[:error].should == "Error: requested meeting_request not found" }

      it { should redirect_to(section_meeting_requests_path) }
    end
  end

  describe "GET new" do

    context "a meeting shift exists for the section" do

      before(:each) do
        mock_meeting_shift = stub_model(Shift)
        @mock_section.stub!(:meeting_shift) { mock_meeting_shift }
        MeetingRequest.should_receive(:new).and_return(mock_request)
        get :new, :section_id => @mock_section.id
      end

      it { assigns(:meeting_request).should eq(mock_request) }
    end

    context "no meeting shift exists for the section" do
      
      before(:each) do
        @mock_section.stub!(:meeting_shift)
        get :new, :section_id => @mock_section.id
      end

      it { should redirect_to(section_meeting_requests_path(@mock_section)) }

      it { flash[:error].should eq("Unable to add meeting requests at this time, please notify your administrator.") }
    end
  end

  describe "POST create" do

    before(:each) do
      @section_meeting_requests = stub("meeting_requests", :<< => nil)
      @mock_section.stub!(:meeting_requests) { @section_meeting_requests }
      @mock_section.stub!(:meeting_shift) 
      MeetingRequest.stub!(:new).and_return(mock_request)
    end

    context "always" do

      before(:each) do
        mock_shift = stub_model(Shift)
        @mock_section.stub!(:meeting_shift) { mock_shift }
        MeetingRequest.should_receive(:new).
          with("these" => :params, "shift" => mock_shift).
          and_return(mock_request)
        post :create, :section_id => @mock_section.id,
          :meeting_request => { :these => :params }
      end

      it { assigns(:meeting_request).should eq(mock_request) }
    end

    context "with valid parameters" do

      before(:each) do
        @section_meeting_requests.should_receive(:<<).with(mock_request).
          and_return(true)
        @mock_section.stub!(:administrators).
          and_return([stub("admin", :email => "foo@bar.com")])
        mock_notification = stub("notification")
        mock_notification.should_receive(:deliver)
        UserNotifications.should_receive(:new_meeting_request).
          with(mock_request, @mock_section.administrators.map(&:email)).
          and_return(mock_notification)
        post :create, :section_id => @mock_section.id, :meeting_request => {}
      end

      it { should redirect_to(section_meeting_requests_path(@mock_section)) }

      it { flash[:notice].should eq("Successfully submitted meeting request") }
    end

    context "with invalid parameters" do

      before(:each) do
        @section_meeting_requests.should_receive(:<<).with(mock_request).and_return(false)
        post :create, :section_id => @mock_section.id, :meeting_request => {}
      end

      it { should render_template(:new) }

      it { flash[:error].should match(/Unable to submit meeting request:/) }
    end
  end

  describe "GET edit" do

    before(:each) do
      @mock_requests = mock("meeting_requests")
      @mock_section.stub!(:meeting_requests).and_return(@mock_requests)
      controller.should_receive(:authenticate_user!)
      controller.should_receive(:authorize!).with(:manage, @mock_section)
    end

    context "the requested meeting_request is found" do

      before(:each) do
        @mock_requests.should_receive(:find).with(mock_request.id).
          and_return(mock_request)
        get :edit, :section_id => @mock_section.id,
          :id => mock_request.id
      end

      it { assigns(:meeting_request).should eq(mock_request) }

      it { should render_template(:edit) }
    end

    context "the requested meeting_request is not found" do

      before(:each) do
        @mock_requests.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        get :edit, :section_id => @mock_section.id, :id => 1
      end

      it { flash[:error].should == "Error: requested meeting_request not found" }

      it { should redirect_to(section_meeting_requests_path) }
    end
  end

  describe "PUT update" do

    before(:each) do
      @mock_requests = mock("meeting_requests")
      @mock_section.stub!(:meeting_requests).
        and_return(@mock_requests)
      controller.should_receive(:authenticate_user!)
      controller.should_receive(:authorize!).with(:manage, @mock_section)
    end

    context "the requested meeting_request is found" do

      context "always" do

        before(:each) do
          mock_request.should_receive(:update_attributes).
            with("these" => :params)
          @mock_requests.should_receive(:find).
            with(mock_request.id).
            and_return(mock_request)
          put :update, :section_id => @mock_section.id,
            :id => mock_request.id, :meeting_request => { :these => :params }
        end

        it { assigns(:meeting_request).should eq(mock_request) }
      end

      context "with valid parameters" do

        before(:each) do
          @mock_requests.stub!(:find).
            and_return(mock_request(:update_attributes => true))
          put :update, :section_id => @mock_section.id,
            :id => mock_request.id
        end

        it { should redirect_to(section_meeting_requests_path(@mock_section)) }

        it { flash[:notice].should eq("Successfully updated meeting request") }
      end

      context "with invalid parameters" do

        before(:each) do
          @mock_requests.stub!(:find).
            and_return(mock_request(:update_attributes => false))
          put :update, :section_id => @mock_section.id,
            :id => mock_request.id
        end

        it { should render_template(:edit) }

        it { flash[:error].should match(/Unable to update meeting request/) }
      end
    end

    context "the requested meeting_request is not found" do

      before(:each) do
        @mock_requests.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        put :update, :section_id => @mock_section.id,
          :id => mock_request.id
      end

      it { flash[:error].should == "Error: requested meeting_request not found" }

      it { should redirect_to(section_meeting_requests_path(@mock_section)) }
    end
  end

  describe "POST 'approve'" do

    before(:each) do
      @mock_requests = mock("meeting_requests")
      @mock_requests.stub!(:find).with(mock_request.id) { mock_request }
      @mock_section.stub!(:meeting_requests) { @mock_requests }
      controller.should_receive(:authenticate_user!)
      controller.should_receive(:authorize!).with(:manage, @mock_section)
    end

    context "is successful" do

      before(:each) do
        mock_request.should_receive(:approve) { true }
        post :approve, :section_id => @mock_section.id, :id => mock_request.id
      end

      it { flash[:notice].should eq("Successfully approved meeting request") }

      it { should redirect_to(section_meeting_requests_path(@mock_section)) }
    end

    context "is not successful" do

      before(:each) do
        mock_request.stub!(:approve) { false }
        post :approve, :section_id => @mock_section.id, :id => mock_request.id
      end

      it { flash[:error].should match(/Unable to approve meeting request:/) }

      it { should redirect_to(section_meeting_requests_path(@mock_section)) }
    end
  end
end