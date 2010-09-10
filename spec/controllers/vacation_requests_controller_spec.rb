require 'spec_helper'

describe VacationRequestsController do

  def mock_vacation_request(stubs={})
    @mock_vacation_request ||= mock_model(VacationRequest, stubs).as_null_object
  end

  before(:each) do
    @mock_section = mock_model(Section, :vacation_requests => [])
    Section.stub!(:find).with(@mock_section.id).and_return(@mock_section)
  end

  describe "GET index" do

    before(:each) do
      @mock_section.stub!(:vacation_requests).and_return([mock_vacation_request])
      get :index, :section_id => @mock_section.id
    end
    
    it { assigns(:vacation_requests).should eq([mock_vacation_request]) }
  end

  describe "GET show" do

    before(:each) do
      @mock_vacation_requests = mock("vacation_requests")
      @mock_section.stub!(:vacation_requests).and_return(@mock_vacation_requests)
    end

    context "the requested vacation_request is found" do

      before(:each) do
        @mock_vacation_requests.should_receive(:find).with(mock_vacation_request.id).
          and_return(mock_vacation_request)
        get :show, :section_id => @mock_section.id,
          :id => mock_vacation_request.id
      end

      it { assigns(:vacation_request).should eq(mock_vacation_request) }
    end

    context "the requested vacation_request is not found" do

      before(:each) do
        @mock_vacation_requests.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        get :show, :section_id => @mock_section.id, :id => 1
      end

      it { flash[:error].should == "Error: requested vacation_request not found" }

      it { should redirect_to(section_vacation_requests_path) }
    end
  end

  describe "GET new" do

    before(:each) do
      VacationRequest.should_receive(:new).and_return(mock_vacation_request)
      get :new, :section_id => @mock_section.id
    end

    it { assigns(:vacation_request).should eq(mock_vacation_request) }
  end

  describe "POST create" do

    before(:each) do
      @section_vacation_requests = stub("vacation_requests", :<< => nil)
      @mock_section.stub!(:vacation_requests).and_return(@section_vacation_requests)
      VacationRequest.stub!(:new).and_return(mock_vacation_request)
    end

    context "always" do

      before(:each) do
        VacationRequest.should_receive(:new).
          with("these" => :params).
          and_return(mock_vacation_request)
        post :create, :section_id => @mock_section.id,
          :vacation_request => { :these => :params }
      end

      it { assigns(:vacation_request).should eq(mock_vacation_request) }
    end

    context "with valid parameters" do

      before(:each) do
        @section_vacation_requests.should_receive(:<<).with(mock_vacation_request).and_return(true)
        post :create, :section_id => @mock_section.id
      end

      it { should redirect_to(section_vacation_requests_path(@mock_section)) }
    end

    context "with invalid parameters" do

      before(:each) do
        @section_vacation_requests.should_receive(:<<).with(mock_vacation_request).and_return(false)
        post :create, :section_id => @mock_section.id
      end

      it { should render_template(:new) }
    end
  end

  describe "GET edit" do

    before(:each) do
      @mock_vacation_requests = mock("vacation_requests")
      @mock_section.stub!(:vacation_requests).and_return(@mock_vacation_requests)
    end

    context "the requested vacation_request is found" do

      before(:each) do
        @mock_vacation_requests.should_receive(:find).with(mock_vacation_request.id).
          and_return(mock_vacation_request)
        get :edit, :section_id => @mock_section.id,
          :id => mock_vacation_request.id
      end

      it { assigns(:vacation_request).should eq(mock_vacation_request) }

      it { should render_template(:edit) }
    end

    context "the requested vacation_request is not found" do

      before(:each) do
        @mock_vacation_requests.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        get :edit, :section_id => @mock_section.id, :id => 1
      end

      it { flash[:error].should == "Error: requested vacation_request not found" }

      it { should redirect_to(section_vacation_requests_path) }
    end
  end

  describe "PUT update" do

    before(:each) do
      @mock_vacation_requests = mock("vacation_requests")
      @mock_section.stub!(:vacation_requests).
        and_return(@mock_vacation_requests)
    end

    context "the requested vacation_request is found" do

      context "always" do

        before(:each) do
          mock_vacation_request.should_receive(:update_attributes).
            with("these" => :params)
          @mock_vacation_requests.should_receive(:find).
            with(mock_vacation_request.id).
            and_return(mock_vacation_request)
          put :update, :section_id => @mock_section.id,
            :id => mock_vacation_request.id, :vacation_request => { :these => :params }
        end

        it { assigns(:vacation_request).should eq(mock_vacation_request) }
      end

      context "with valid parameters" do

        before(:each) do
          @mock_vacation_requests.stub!(:find).
            and_return(mock_vacation_request(:update_attributes => true))
          put :update, :section_id => @mock_section.id,
            :id => mock_vacation_request.id
        end

        it { should redirect_to(section_vacation_request_path(@mock_section, mock_vacation_request)) }
      end

      context "with invalid parameters" do

        before(:each) do
          @mock_vacation_requests.stub!(:find).
            and_return(mock_vacation_request(:update_attributes => false))
          put :update, :section_id => @mock_section.id,
            :id => mock_vacation_request.id
        end

        it { should render_template(:edit) }
      end
    end

    context "the requested vacation_request is not found" do

      before(:each) do
        @mock_vacation_requests.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        put :update, :section_id => @mock_section.id,
          :id => mock_vacation_request.id
      end

      it { flash[:error].should == "Error: requested vacation_request not found" }

      it { should redirect_to(section_vacation_requests_path(@mock_section)) }
    end
  end

  describe "DELETE destroy" do

    before(:each) do
      @mock_vacation_requests = mock("vacation_requests")
      @mock_section.stub!(:vacation_requests).and_return(@mock_vacation_requests)
    end

    context "the requested vacation_request is found" do

      before(:each) do
        @mock_vacation_requests.stub!(:find).with(mock_vacation_request.id).
          and_return(mock_vacation_request)
      end

      context "and destroyed successfully" do

        before(:each) do
          mock_vacation_request.should_receive(:destroy).and_return(true)
          delete :destroy, :section_id => @mock_section.id,
            :id => mock_vacation_request.id
        end

        it { flash[:notice].should == "Successfully deleted vacation_request" }

        it { should redirect_to(section_vacation_requests_path(@mock_section)) }
      end

      context "and not destroyed successfully" do

        before(:each) do
          mock_vacation_request.should_receive(:destroy).and_return(false)
          delete :destroy, :section_id => @mock_section.id,
            :id => mock_vacation_request.id
        end

        it { flash[:error].should == "Error: failed to delete vacation_request" }

        it { should redirect_to(section_vacation_requests_path(@mock_section)) }
      end
    end

    context "the requested vacation_request is not found" do

      before(:each) do
        @mock_vacation_requests.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        delete :destroy, :section_id => @mock_section.id,
          :id => mock_vacation_request.id
      end

      it { flash[:error].should == "Error: requested vacation_request not found" }

      it { should redirect_to(section_vacation_requests_path(@mock_section)) }
    end
  end
end
