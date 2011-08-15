require 'spec_helper'

describe AssignmentRequestsController do

  include Devise::TestHelpers

  def mock_request(stubs={})
    (@mock_request ||= mock_model(AssignmentRequest).as_null_object).tap do |v_request|
      v_request.stub(stubs) unless stubs.empty?
    end
  end

  let(:mock_section) { mock_model(Section, :assignment_requests => []) }
  let(:mock_user) { mock_model(User, :physician_id => 7) }

  before(:each) do
    Section.stub!(:find).with(mock_section.id.to_s) { mock_section }
  end

  describe "GET index" do

    before(:each) do
      mock_section.stub!(:assignment_requests) { [mock_request] }
      get :index, :section_id => mock_section.id
    end
    
    it { assigns(:assignment_requests).should eq([mock_request]) }
  end

  describe "GET new" do

    it "should redirect if the user is not authenticated" do
      sign_out mock_user
      get :new, :section_id => mock_section.id
      should redirect_to(new_user_session_path)
    end

    context "when the user is authenticated" do

      before(:each) do
        controller.stub!(:authenticate_user!)
        controller.stub!(:current_user) { mock_user }
        AssignmentRequest.should_receive(:new).
          with(:requester_id => mock_user.physician_id).
          and_return(mock_request)
        get :new, :section_id => mock_section.id
      end

      it { assigns(:assignment_request).should eq(mock_request) }
    end
  end

  describe "POST create" do

    before(:each) do
      controller.should_receive(:authenticate_user!)
      controller.stub!(:authorize!)
      controller.stub!(:current_user) { mock_user }
      AssignmentRequest.stub!(:new) { mock_request }
    end

    context "the current user is not associated with the requester" do

      it "should determine if the user is authorized to manage the section" do
        mock_user.stub!(:physician_id)
        controller.should_receive(:authorize!).with(:manage, mock_section)
        post :create, :section_id => mock_section.id,
          :assignment_request => { :requester_id => mock_user.physician_id }
      end
    end

    context "always" do

      before(:each) do
        AssignmentRequest.should_receive(:new).
          with("these" => "params").
          and_return(mock_request)
        post :create, :section_id => mock_section.id,
          :assignment_request => { :these => :params }
      end

      it { assigns(:assignment_request).should eq(mock_request) }
    end

    context "with valid parameters" do

      before(:each) do
        mock_request.stub!(:save) { true }
        post :create, :section_id => mock_section.id, :assignment_request => {}
      end

      it { should redirect_to(section_assignment_requests_path(mock_section)) }

      it { flash[:notice].should eq("Successfully submitted assignment request") }
    end

    context "with invalid parameters" do

      before(:each) do
        mock_request.stub!(:save) { false }
        post :create, :section_id => mock_section.id, :assignment_request => {}
      end

      it { should render_template(:new) }

      it { flash[:error].should match(/Unable to submit assignment request:/) }
    end
  end

  describe "GET edit" do

    before(:each) do
      @mock_requests = mock("assignment_requests")
      mock_section.stub!(:assignment_requests) { @mock_requests }
      controller.should_receive(:authenticate_user!)
      controller.should_receive(:authorize!).with(:manage, mock_section)
    end

    context "the requested assignment request is found" do

      before(:each) do
        @mock_requests.should_receive(:find).with(mock_request.id.to_s).
          and_return(mock_request)
        get :edit, :section_id => mock_section.id,
          :id => mock_request.id
      end

      it { assigns(:assignment_request).should eq(mock_request) }

      it { should render_template(:edit) }
    end

    context "the requested assignment_request is not found" do

      before(:each) do
        @mock_requests.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        get :edit, :section_id => mock_section.id, :id => 1
      end

      it { flash[:error].should == "Error: requested assignment request not found" }

      it { should redirect_to(section_assignment_requests_path) }
    end
  end

  describe "PUT update" do

    before(:each) do
      @mock_requests = mock("assignment_requests")
      mock_section.stub!(:assignment_requests) { @mock_requests }
      controller.should_receive(:authenticate_user!)
      controller.should_receive(:authorize!).with(:manage, mock_section)
    end

    context "the requested assignment_request is found" do

      context "always" do

        before(:each) do
          mock_request.should_receive(:update_attributes).
            with("these" => "params")
          @mock_requests.should_receive(:find).
            with(mock_request.id.to_s).
            and_return(mock_request)
          put :update, :section_id => mock_section.id,
            :id => mock_request.id, :assignment_request => { :these => :params }
        end

        it { assigns(:assignment_request).should eq(mock_request) }
      end

      context "with valid parameters" do

        before(:each) do
          @mock_requests.stub!(:find).
            and_return(mock_request(:update_attributes => true))
          put :update, :section_id => mock_section.id,
            :id => mock_request.id
        end

        it { should redirect_to(section_assignment_requests_path(mock_section)) }

        it { flash[:notice].should eq("Successfully updated assignment request") }
      end

      context "with invalid parameters" do

        before(:each) do
          @mock_requests.stub!(:find).
            and_return(mock_request(:update_attributes => false))
          put :update, :section_id => mock_section.id,
            :id => mock_request.id
        end

        it { should render_template(:edit) }

        it { flash[:error].should match(/Unable to update assignment request/) }
      end
    end

    context "the requested assignment_request is not found" do

      before(:each) do
        @mock_requests.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        put :update, :section_id => mock_section.id,
          :id => mock_request.id
      end

      it { flash[:error].should == "Error: requested assignment request not found" }

      it { should redirect_to(section_assignment_requests_path(mock_section)) }
    end
  end

  describe "POST 'approve'" do

    before(:each) do
      @mock_requests = mock("assignment_requests")
      @mock_requests.stub!(:find).with(mock_request.id.to_s) { mock_request }
      mock_section.stub!(:assignment_requests) { @mock_requests }
      controller.should_receive(:authenticate_user!)
      controller.should_receive(:authorize!).with(:manage, mock_section)
    end

    context "is successful" do

      before(:each) do
        mock_request.should_receive(:approve!) { true }
        post :approve, :section_id => mock_section.id, :id => mock_request.id
      end

      it { flash[:notice].should eq("Successfully approved assignment request") }

      it { should redirect_to(section_assignment_requests_path(mock_section)) }
    end

    context "is not successful" do

      before(:each) do
        mock_request.stub!(:approve!) { false }
        post :approve, :section_id => mock_section.id, :id => mock_request.id
      end

      it { flash[:error].should match(/Unable to approve assignment request:/) }

      it { should redirect_to(section_assignment_requests_path(mock_section)) }
    end
  end
end
