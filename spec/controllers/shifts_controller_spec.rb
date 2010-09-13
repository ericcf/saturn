require 'spec_helper'

describe ShiftsController do

  def mock_shift(stubs={})
    @mock_shift ||= mock_model(Shift, stubs).as_null_object
  end

  before(:each) do
    shifts_subset = stub("shifts subset", :find => nil)
    @section_shifts = stub("shifts", :active_as_of => shifts_subset,
      :retired_as_of => shifts_subset)
    @mock_section = mock_model(Section, :shifts => @section_shifts)
    Section.stub!(:find).with(@mock_section.id).
      and_return(@mock_section)
    controller.should_receive(:authenticate_user!)
  end

  describe "GET index" do

    context "shifts that have not been retired" do

      before(:each) do
        active_shifts = mock("active shifts")
        @section_shifts.should_receive(:active_as_of).
          with(Date.today).
          and_return(active_shifts)
        active_shifts.should_receive(:find).
          with(:all, :include => :shift_tags).
          and_return([mock_shift])
        get :index, :section_id => @mock_section.id
      end
      
      it { assigns(:current_shifts).should eq([mock_shift]) }
    end

    context "shifts that have been retired" do

      before(:each) do
        retired_shifts = mock("retired shifts")
        @section_shifts.should_receive(:retired_as_of).
          with(Date.today).
          and_return(retired_shifts)
        retired_shifts.should_receive(:find).
          with(:all, :include => :shift_tags).
          and_return([mock_shift])
        get :index, :section_id => @mock_section.id
      end
      
      it { assigns(:retired_shifts).should eq([mock_shift]) }
    end
  end

  describe "GET show" do

    before(:each) do
      @mock_shifts = mock("shifts")
      @mock_section.stub!(:shifts).and_return(@mock_shifts)
    end

    context "the requested shift is found" do

      before(:each) do
        @mock_shifts.should_receive(:find).with(mock_shift.id).
          and_return(mock_shift)
        get :show, :section_id => @mock_section.id,
          :id => mock_shift.id
      end

      it { assigns(:shift).should eq(mock_shift) }
    end

    context "the requested shift is not found" do

      before(:each) do
        @mock_shifts.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        get :show, :section_id => @mock_section.id, :id => 1
      end

      it { flash[:error].should == "Error: requested shift not found" }

      it { should redirect_to(section_shifts_path) }
    end
  end

  describe "GET new" do

    before(:each) do
      Shift.should_receive(:new).and_return(mock_shift)
      get :new, :section_id => @mock_section.id
    end

    it { assigns(:shift).should eq(mock_shift) }
  end

  describe "POST create" do

    before(:each) do
      @section_shifts = stub("shifts", :<< => nil)
      @mock_section.stub!(:shifts).and_return(@section_shifts)
      Shift.stub!(:new).and_return(mock_shift)
    end

    context "always" do

      before(:each) do
        Shift.should_receive(:new).
          with("these" => :params).
          and_return(mock_shift)
        post :create, :section_id => @mock_section.id,
          :shift => { :these => :params }
      end

      it { assigns(:shift).should eq(mock_shift) }
    end

    context "with valid parameters" do

      before(:each) do
        @section_shifts.should_receive(:<<).with(mock_shift).and_return(true)
        post :create, :section_id => @mock_section.id
      end

      it { should redirect_to(section_shifts_path(@mock_section)) }
    end

    context "with invalid parameters" do

      before(:each) do
        @section_shifts.should_receive(:<<).with(mock_shift).and_return(false)
        post :create, :section_id => @mock_section.id
      end

      it { should render_template(:new) }
    end
  end

  describe "GET edit" do

    before(:each) do
      @mock_shifts = mock("shifts")
      @mock_section.stub!(:shifts).and_return(@mock_shifts)
    end

    context "the requested shift is found" do

      before(:each) do
        @mock_shifts.should_receive(:find).with(mock_shift.id).
          and_return(mock_shift)
        get :edit, :section_id => @mock_section.id,
          :id => mock_shift.id
      end

      it { assigns(:shift).should eq(mock_shift) }

      it { should render_template(:edit) }
    end

    context "the requested shift is not found" do

      before(:each) do
        @mock_shifts.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        get :edit, :section_id => @mock_section.id, :id => 1
      end

      it { flash[:error].should == "Error: requested shift not found" }

      it { should redirect_to(section_shifts_path) }
    end
  end

  describe "PUT update" do

    before(:each) do
      @mock_shifts = mock("shifts")
      @mock_section.stub!(:shifts).and_return(@mock_shifts)
    end

    context "the requested shift is found" do

      context "always" do

        before(:each) do
          mock_shift.should_receive(:update_attributes).
            with("these" => :params)
          @mock_shifts.should_receive(:find).with(mock_shift.id).
            and_return(mock_shift)
          put :update, :section_id => @mock_section.id,
            :id => mock_shift.id, :shift => { :these => :params }
        end

        it { assigns(:shift).should eq(mock_shift) }
      end

      context "with valid parameters" do

        before(:each) do
          @mock_shifts.stub!(:find).
            and_return(mock_shift(:update_attributes => true))
          put :update, :section_id => @mock_section.id,
            :id => mock_shift.id
        end

        it { should redirect_to(section_shift_path(@mock_section, mock_shift)) }
      end

      context "with invalid parameters" do

        before(:each) do
          @mock_shifts.stub!(:find).
            and_return(mock_shift(:update_attributes => false))
          put :update, :section_id => @mock_section.id,
            :id => mock_shift.id
        end

        it { should render_template(:edit) }
      end
    end

    context "the requested shift is not found" do

      before(:each) do
        @mock_shifts.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        put :update, :section_id => @mock_section.id,
          :id => mock_shift.id
      end

      it { flash[:error].should == "Error: requested shift not found" }

      it { should redirect_to(section_shifts_path(@mock_section)) }
    end
  end

  describe "DELETE destroy" do

    before(:each) do
      @mock_shifts = mock("shifts")
      @mock_section.stub!(:shifts).and_return(@mock_shifts)
    end

    context "the requested shift is found" do

      before(:each) do
        @mock_shifts.stub!(:find).with(mock_shift.id).
          and_return(mock_shift)
      end

      context "and destroyed successfully" do

        before(:each) do
          mock_shift.should_receive(:destroy).and_return(true)
          delete :destroy, :section_id => @mock_section.id,
            :id => mock_shift.id
        end

        it { flash[:notice].should == "Successfully deleted shift" }

        it { should redirect_to(section_shifts_path(@mock_section)) }
      end

      context "and not destroyed successfully" do

        before(:each) do
          mock_shift.should_receive(:destroy).and_return(false)
          delete :destroy, :section_id => @mock_section.id,
            :id => mock_shift.id
        end

        it { flash[:error].should == "Error: failed to delete shift" }

        it { should redirect_to(section_shifts_path(@mock_section)) }
      end
    end

    context "the requested shift is not found" do

      before(:each) do
        @mock_shifts.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        delete :destroy, :section_id => @mock_section.id,
          :id => mock_shift.id
      end

      it { flash[:error].should == "Error: requested shift not found" }

      it { should redirect_to(section_shifts_path(@mock_section)) }
    end
  end
end
