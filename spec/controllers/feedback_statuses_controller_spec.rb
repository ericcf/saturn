require 'spec_helper'

describe FeedbackStatusesController do

  def mock_feedback_status(stubs={})
    @mock_feedback_status ||= mock_model(FeedbackStatus, stubs).as_null_object
  end

  before(:each) do
    controller.should_receive(:authenticate_user!)
  end

  describe "GET index" do

    before(:each) do
      FeedbackStatus.stub!(:all).and_return([mock_feedback_status])
      get :index
    end
    
    it { assigns(:feedback_statuses).should eq([mock_feedback_status]) }
  end

  describe "GET show" do

    context "the requested status is found" do

      before(:each) do
        FeedbackStatus.stub!(:find).and_return(mock_feedback_status)
        get :show, :id => mock_feedback_status.id
      end

      it { assigns(:feedback_status).should eq(mock_feedback_status) }

      it { should render_template(:show) }
    end

    context "the requested status is not found" do

      before(:each) do
        FeedbackStatus.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        get :show, :id => mock_feedback_status.id
      end

      it { flash[:error].should == "Error: requested status not found" }

      it { should redirect_to(feedback_statuses_path) }
    end
  end

  describe "GET new" do

    before(:each) do
      FeedbackStatus.should_receive(:new).and_return(mock_feedback_status)
      controller.should_receive(:authorize!).with(:create, FeedbackStatus)
      get :new
    end

    it { assigns(:feedback_status).should eq(mock_feedback_status) }
  end

  describe "POST create" do

    before(:each) do
      controller.should_receive(:authorize!).with(:create, FeedbackStatus)
    end

    context "always" do

      before(:each) do
        FeedbackStatus.should_receive(:new).
          with("these" => :params).
          and_return(mock_feedback_status)
        post :create, :feedback_status => { :these => :params }
      end

      it { assigns(:feedback_status).should eq(mock_feedback_status) }
    end

    context "with valid parameters" do

      before(:each) do
        FeedbackStatus.stub!(:new).and_return(mock_feedback_status(:save => true))
        post :create
      end

      it { should redirect_to(feedback_statuses_path) }
    end

    context "with invalid parameters" do

      before(:each) do
        FeedbackStatus.stub!(:new).and_return(mock_feedback_status(:save => false))
        post :create
      end

      it { should render_template(:new) }
    end
  end

  describe "GET edit" do

    context "the feedback_status is found" do

      before(:each) do
        FeedbackStatus.stub!(:find).and_return(mock_feedback_status)
        controller.should_receive(:authorize!).
          with(:update, mock_feedback_status)
        get :edit, :id => mock_feedback_status.id
      end

      it { assigns(:feedback_status).should eq(mock_feedback_status) }

      it { should render_template(:edit) }
    end

    context "the feedback_status is not found" do

      before(:each) do
        FeedbackStatus.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        get :edit, :id => mock_feedback_status.id
      end

      it { flash[:error].should == "Error: requested status not found" }

      it { should redirect_to(feedback_statuses_path) }
    end
  end

  describe "PUT update" do

    context "the requested feedback_status is found" do
    
      before(:each) do
        FeedbackStatus.stub!(:find).and_return(mock_feedback_status)
        controller.should_receive(:authorize!).
          with(:update, mock_feedback_status)
      end

      context "always" do

        it "updates with the provided attributes" do
          mock_feedback_status.should_receive(:update_attributes).
            with("these" => :params)
          put :update, :id => mock_feedback_status.id,
            :feedback_status => { :these => :params }
        end
      end

      context "it updates successfully" do

        before(:each) do
          mock_feedback_status.stub!(:update_attributes).and_return(true)
          put :update, :id => mock_feedback_status.id
        end

        it { should redirect_to(feedback_statuses_path) }
      end

      context "it does not update successfully" do

        before(:each) do
          mock_feedback_status.stub!(:update_attributes).and_return(false)
          put :update, :id => mock_feedback_status.id
        end

        it { should render_template(:edit) }
      end
    end

    context "the feedback_status is not found" do

      before(:each) do
        FeedbackStatus.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        put :update, :id => mock_feedback_status.id
      end

      it { flash[:error].should == "Error: requested status not found" }

      it { should redirect_to(feedback_statuses_path) }
    end
  end

  describe "DELETE destroy" do

    context "the requested feedback_status is found" do

      before(:each) do
        FeedbackStatus.stub!(:find).and_return(mock_feedback_status)
        controller.should_receive(:authorize!).
          with(:destroy, mock_feedback_status)
      end

      context "and destroyed successfully" do

        before(:each) do
          mock_feedback_status.should_receive(:destroy).and_return(true)
          delete :destroy, :id => mock_feedback_status.id
        end

        it { flash[:notice].should == "Successfully deleted status" }

        it { should redirect_to(feedback_statuses_path) }
      end

      context "and not destroyed successfully" do

        before(:each) do
          mock_feedback_status.should_receive(:destroy).and_return(false)
          delete :destroy, :id => mock_feedback_status.id
        end

        it { flash[:error].should == "Error: failed to delete status" }

        it { should redirect_to(feedback_statuses_path) }
      end
    end

    context "the requested feedback_status is not found" do

      before(:each) do
        FeedbackStatus.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        delete :destroy, :id => mock_feedback_status.id
      end

      it { flash[:error].should == "Error: requested status not found" }

      it { should redirect_to(feedback_statuses_path) }
    end
  end
end
