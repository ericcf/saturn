require 'spec_helper'

describe RotationsController do

  def mock_rotation(stubs={})
    @mock_rotation ||= mock_model(Rotation, stubs).as_null_object
  end

  before(:each) do
    controller.should_receive(:authenticate_user!)
    controller.should_receive(:authorize!).with(:manage, Rotation)
  end

  describe "GET index" do

    before(:each) do
      Rotation.stub!(:all).and_return([mock_rotation])
      get :index
    end
    
    it { assigns(:rotations).should eq([mock_rotation]) }
  end

  describe "GET new" do

    before(:each) do
      Rotation.should_receive(:new).and_return(mock_rotation)
      get :new
    end

    it { assigns(:rotation).should eq(mock_rotation) }
  end

  describe "POST create" do

    context "always" do

      before(:each) do
        Rotation.should_receive(:new).
          with("these" => :params).
          and_return(mock_rotation)
        post :create, :rotation => { :these => :params }
      end

      it { assigns(:rotation).should eq(mock_rotation) }
    end

    context "with valid parameters" do

      before(:each) do
        Rotation.stub!(:new).and_return(mock_rotation(:save => true))
        post :create
      end

      it { should redirect_to(rotations_path) }
    end

    context "with invalid parameters" do

      before(:each) do
        Rotation.stub!(:new).and_return(mock_rotation(:save => false))
        post :create
      end

      it { should render_template(:new) }
    end
  end

  describe "GET edit" do

    context "the rotation is found" do

      before(:each) do
        Rotation.stub!(:find).and_return(mock_rotation)
        get :edit, :id => mock_rotation.id
      end

      it { assigns(:rotation).should eq(mock_rotation) }

      it { should render_template(:edit) }
    end

    context "the rotation is not found" do

      before(:each) do
        Rotation.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        get :edit, :id => mock_rotation.id
      end

      it { flash[:error].should == "Error: requested rotation not found" }

      it { should redirect_to(rotations_path) }
    end
  end

  describe "PUT update" do

    context "the requested rotation is found" do
    
      before(:each) do
        Rotation.stub!(:find).and_return(mock_rotation)
      end

      context "always" do

        it "updates with the provided attributes" do
          mock_rotation.should_receive(:update_attributes).
            with("these" => :params)
          put :update, :id => mock_rotation.id,
            :rotation => { :these => :params }
        end
      end

      context "it updates successfully" do

        before(:each) do
          mock_rotation.stub!(:update_attributes).and_return(true)
          put :update, :id => mock_rotation.id
        end

        it { should redirect_to(rotations_path) }
      end

      context "it does not update successfully" do

        before(:each) do
          mock_rotation.stub!(:update_attributes).and_return(false)
          put :update, :id => mock_rotation.id
        end

        it { should render_template(:edit) }
      end
    end
  end

  describe "DELETE destroy" do

    context "the requested rotation is found" do

      before(:each) do
        Rotation.stub!(:find).and_return(mock_rotation)
      end

      context "and destroyed successfully" do

        before(:each) do
          mock_rotation.should_receive(:destroy).and_return(true)
          delete :destroy, :id => mock_rotation.id
        end

        it { flash[:notice].should == "Successfully deleted rotation" }

        it { should redirect_to(rotations_path) }
      end

      context "and not destroyed successfully" do

        before(:each) do
          mock_rotation.should_receive(:destroy).and_return(false)
          delete :destroy, :id => mock_rotation.id
        end

        it { flash[:error].should == "Error: failed to delete rotation" }

        it { should redirect_to(rotations_path) }
      end
    end

    context "the requested rotation is not found" do

      before(:each) do
        Rotation.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        delete :destroy, :id => mock_rotation.id
      end

      it { flash[:error].should == "Error: requested rotation not found" }

      it { should redirect_to(rotations_path) }
    end
  end
end
