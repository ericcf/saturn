require 'spec_helper'

describe HelpQuestionsController do

  def mock_help_question(stubs={})
    @mock_help_question ||= mock_model(HelpQuestion, stubs).as_null_object
  end

  describe "GET index" do

    before(:each) do
      HelpQuestion.stub!(:all).and_return([mock_help_question])
      get :index
    end
    
    it { assigns(:help_questions).should eq([mock_help_question]) }
  end

  describe "GET new" do

    before(:each) do
      controller.should_receive(:authenticate_user!)
      HelpQuestion.should_receive(:new).and_return(mock_help_question)
      get :new
    end

    it { assigns(:help_question).should eq(mock_help_question) }
  end

  describe "POST create" do

    before(:each) do
      controller.should_receive(:authenticate_user!)
    end

    context "always" do

      before(:each) do
        HelpQuestion.should_receive(:new).
          with("these" => :params).
          and_return(mock_help_question)
        post :create, :help_question => { :these => :params }
      end

      it { assigns(:help_question).should eq(mock_help_question) }
    end

    context "with valid parameters" do

      before(:each) do
        HelpQuestion.stub!(:new).and_return(mock_help_question(:save => true))
        post :create
      end

      it { should redirect_to(help_questions_path) }
    end

    context "with invalid parameters" do

      before(:each) do
        HelpQuestion.stub!(:new).and_return(mock_help_question(:save => false))
        post :create
      end

      it { should render_template(:new) }
    end
  end

  describe "GET edit" do

    before(:each) do
      controller.should_receive(:authenticate_user!)
    end

    context "the help_question is found" do

      before(:each) do
        HelpQuestion.stub!(:find).and_return(mock_help_question)
        controller.should_receive(:authorize!).
          with(:update, mock_help_question)
        get :edit, :id => mock_help_question.id
      end

      it { assigns(:help_question).should eq(mock_help_question) }

      it { should render_template(:edit) }
    end

    context "the help_question is not found" do

      before(:each) do
        HelpQuestion.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        get :edit, :id => mock_help_question.id
      end

      it { flash[:error].should == "Error: requested question not found" }

      it { should redirect_to(help_questions_path) }
    end
  end

  describe "PUT update" do

    before(:each) do
      controller.should_receive(:authenticate_user!)
    end

    context "the requested help_question is found" do
    
      before(:each) do
        HelpQuestion.stub!(:find).and_return(mock_help_question)
        controller.should_receive(:authorize!).
          with(:update, mock_help_question)
      end

      context "always" do

        it "updates with the provided attributes" do
          mock_help_question.should_receive(:update_attributes).
            with("these" => :params)
          put :update, :id => mock_help_question.id,
            :help_question => { :these => :params }
        end
      end

      context "it updates successfully" do

        before(:each) do
          mock_help_question.stub!(:update_attributes).and_return(true)
          put :update, :id => mock_help_question.id
        end

        it { should redirect_to(help_questions_path) }
      end

      context "it does not update successfully" do

        before(:each) do
          mock_help_question.stub!(:update_attributes).and_return(false)
          put :update, :id => mock_help_question.id
        end

        it { should render_template(:edit) }
      end
    end
  end

  describe "DELETE destroy" do

    before(:each) do
      controller.should_receive(:authenticate_user!)
    end

    context "the requested help_question is found" do

      before(:each) do
        HelpQuestion.stub!(:find).and_return(mock_help_question)
        controller.should_receive(:authorize!).
          with(:destroy, mock_help_question)
      end

      context "and destroyed successfully" do

        before(:each) do
          mock_help_question.should_receive(:destroy).and_return(true)
          delete :destroy, :id => mock_help_question.id
        end

        it { flash[:notice].should == "Successfully deleted question" }

        it { should redirect_to(help_questions_path) }
      end

      context "and not destroyed successfully" do

        before(:each) do
          mock_help_question.should_receive(:destroy).and_return(false)
          delete :destroy, :id => mock_help_question.id
        end

        it { flash[:error].should == "Error: failed to delete question" }

        it { should redirect_to(help_questions_path) }
      end
    end

    context "the requested help_question is not found" do

      before(:each) do
        HelpQuestion.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        delete :destroy, :id => mock_help_question.id
      end

      it { flash[:error].should == "Error: requested question not found" }

      it { should redirect_to(help_questions_path) }
    end
  end
end
