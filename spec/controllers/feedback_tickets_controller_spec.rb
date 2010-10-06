require 'spec_helper'

describe FeedbackTicketsController do

  def mock_feedback_ticket(stubs={})
    @mock_feedback_ticket ||= mock_model(FeedbackTicket, stubs).as_null_object
  end

  describe "GET index" do

    before(:each) do
      FeedbackTicket.stub!(:all).and_return([mock_feedback_ticket])
      get :index
    end
    
    it { assigns(:feedback_tickets).should eq([mock_feedback_ticket]) }
  end

  describe "GET show" do

    context "the requested ticket is found" do

      before(:each) do
        FeedbackTicket.stub!(:find).and_return(mock_feedback_ticket)
        get :show, :id => mock_feedback_ticket.id
      end

      it { assigns(:feedback_ticket).should eq(mock_feedback_ticket) }

      it { should render_template(:show) }
    end

    context "the requested ticket is not found" do

      before(:each) do
        FeedbackTicket.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        get :show, :id => mock_feedback_ticket.id
      end

      it { flash[:error].should == "Error: requested ticket not found" }

      it { should redirect_to(feedback_tickets_path) }
    end
  end

  describe "GET new" do

    before(:each) do
      FeedbackTicket.should_receive(:new).and_return(mock_feedback_ticket)
      get :new
    end

    it { assigns(:feedback_ticket).should eq(mock_feedback_ticket) }
  end

  describe "POST create" do

    context "always" do

      before(:each) do
        FeedbackTicket.should_receive(:new).
          with("these" => :params).
          and_return(mock_feedback_ticket)
        post :create, :feedback_ticket => { :these => :params }
      end

      it { assigns(:feedback_ticket).should eq(mock_feedback_ticket) }
    end

    context "with valid parameters" do

      before(:each) do
        FeedbackTicket.stub!(:new).and_return(mock_feedback_ticket(:save => true))
        post :create
      end

      it { should redirect_to(feedback_tickets_path) }
    end

    context "with invalid parameters" do

      before(:each) do
        FeedbackTicket.stub!(:new).and_return(mock_feedback_ticket(:save => false))
        post :create
      end

      it { should render_template(:new) }
    end
  end

  describe "GET edit" do

    before(:each) do
      controller.should_receive(:authenticate_user!)
    end

    context "the feedback_ticket is found" do

      before(:each) do
        FeedbackTicket.stub!(:find).and_return(mock_feedback_ticket)
        controller.should_receive(:authorize!).
          with(:update, mock_feedback_ticket)
        get :edit, :id => mock_feedback_ticket.id
      end

      it { assigns(:feedback_ticket).should eq(mock_feedback_ticket) }

      it { should render_template(:edit) }
    end

    context "the feedback_ticket is not found" do

      before(:each) do
        FeedbackTicket.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        get :edit, :id => mock_feedback_ticket.id
      end

      it { flash[:error].should == "Error: requested ticket not found" }

      it { should redirect_to(feedback_tickets_path) }
    end
  end

  describe "PUT update" do

    before(:each) do
      controller.should_receive(:authenticate_user!)
    end

    context "the requested feedback_ticket is found" do
    
      before(:each) do
        FeedbackTicket.stub!(:find).and_return(mock_feedback_ticket)
        controller.should_receive(:authorize!).
          with(:update, mock_feedback_ticket)
      end

      context "always" do

        it "updates with the provided attributes" do
          mock_feedback_ticket.should_receive(:update_attributes).
            with("these" => :params)
          put :update, :id => mock_feedback_ticket.id,
            :feedback_ticket => { :these => :params }
        end
      end

      context "it updates successfully" do

        before(:each) do
          mock_feedback_ticket.stub!(:update_attributes).and_return(true)
          put :update, :id => mock_feedback_ticket.id
        end

        it { should redirect_to(feedback_tickets_path) }
      end

      context "it does not update successfully" do

        before(:each) do
          mock_feedback_ticket.stub!(:update_attributes).and_return(false)
          put :update, :id => mock_feedback_ticket.id
        end

        it { should render_template(:edit) }
      end
    end
  end

  describe "DELETE destroy" do

    before(:each) do
      controller.should_receive(:authenticate_user!)
    end

    context "the requested feedback_ticket is found" do

      before(:each) do
        FeedbackTicket.stub!(:find).and_return(mock_feedback_ticket)
        controller.should_receive(:authorize!).
          with(:destroy, mock_feedback_ticket)
      end

      context "and destroyed successfully" do

        before(:each) do
          mock_feedback_ticket.should_receive(:destroy).and_return(true)
          delete :destroy, :id => mock_feedback_ticket.id
        end

        it { flash[:notice].should == "Successfully deleted ticket" }

        it { should redirect_to(feedback_tickets_path) }
      end

      context "and not destroyed successfully" do

        before(:each) do
          mock_feedback_ticket.should_receive(:destroy).and_return(false)
          delete :destroy, :id => mock_feedback_ticket.id
        end

        it { flash[:error].should == "Error: failed to delete ticket" }

        it { should redirect_to(feedback_tickets_path) }
      end
    end

    context "the requested feedback_ticket is not found" do

      before(:each) do
        FeedbackTicket.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        delete :destroy, :id => mock_feedback_ticket.id
      end

      it { flash[:error].should == "Error: requested ticket not found" }

      it { should redirect_to(feedback_tickets_path) }
    end
  end
end
