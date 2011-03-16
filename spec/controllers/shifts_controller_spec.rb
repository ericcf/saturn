require 'spec_helper'

describe ShiftsController do

  def mock_shift(stubs={})
    (@mock_shift ||= mock_model(Shift).as_null_object).tap do |shift|
      shift.stub(stubs) unless stubs.empty?
    end
  end

  let(:mock_shifts_subset) { stub("shifts subset") }
  let(:mock_section) { mock_model(Section) }

  before(:each) do
    mock_section.stub_chain("active_shifts.includes")
    mock_section.stub!(:retired_shifts_as_of) { mock_shifts_subset }
    Section.stub!(:find).with(mock_section.id) { mock_section }
    controller.should_receive(:authenticate_user!)
    controller.should_receive(:authorize!).with(:manage, mock_section)
  end

  describe "GET index" do

    context "shifts that have not been retired" do

      before(:each) do
        mock_section.stub_chain("active_shifts.includes").
          and_return([mock_shift])
        get :index, :section_id => mock_section.id
      end
      
      it { assigns(:current_shifts).should eq([mock_shift]) }
    end

    context "shifts that have been retired" do

      before(:each) do
        mock_section.stub!(:retired_shifts_as_of).with(Date.today).
          and_return([mock_shift])
        get :index, :section_id => mock_section.id
      end
      
      it { assigns(:retired_shifts).should eq([mock_shift]) }
    end
  end

  describe "GET new" do

    before(:each) do
      Shift.should_receive(:new) { mock_shift }
      get :new, :section_id => mock_section.id
    end

    it { assigns(:shift).should eq(mock_shift) }
  end

  describe "POST create" do

    before(:each) do
      @section_shifts = stub("shifts", :<< => nil)
      mock_section.stub!(:shifts) { @section_shifts }
      Shift.stub!(:new) { mock_shift } 
    end

    context "always" do

      before(:each) do
        Shift.should_receive(:new).with("these" => :params) { mock_shift }
        post :create, :section_id => mock_section.id,
          :shift => { :these => :params }
      end

      it { assigns(:shift).should eq(mock_shift) }
    end

    context "with valid parameters" do

      before(:each) do
        @section_shifts.should_receive(:<<).with(mock_shift) { true }
        post :create, :section_id => mock_section.id
      end

      it { should redirect_to(section_shifts_path(mock_section)) }

      it { flash[:notice].should eq("Successfully created shift") }
    end

    context "with invalid parameters" do

      before(:each) do
        @section_shifts.should_receive(:<<).with(mock_shift) { false }
        post :create, :section_id => mock_section.id
      end

      it { should render_template(:new) }

      it { flash[:error].should match(/Unable to create shift/) }
    end
  end

  describe "GET edit" do

    let(:mock_shifts) { mock("shifts") }

    before(:each) do
      mock_section.stub!(:shifts) { mock_shifts }
    end

    context "the requested shift is found" do

      before(:each) do
        mock_shifts.stub!(:find).with(mock_shift.id) { mock_shift }
        get :edit, :section_id => mock_section.id, :id => mock_shift.id
      end

      it { assigns(:shift).should eq(mock_shift) }

      it { should render_template(:edit) }
    end

    context "the requested shift is not found" do

      before(:each) do
        mock_shifts.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        get :edit, :section_id => mock_section.id, :id => mock_shift.id
      end

      it { flash[:error].should == "Error: requested shift not found" }

      it { should redirect_to(section_shifts_path(mock_section)) }
    end
  end

  describe "PUT update" do

    let(:mock_shifts) { mock("shifts") }

    before(:each) do
      mock_section.stub_chain("shifts.readonly") { mock_shifts }
    end

    context "the requested shift is found" do

      before(:each) do
        mock_shifts.stub!(:find).with(mock_shift.id) { mock_shift }
      end

      context "always" do

        before(:each) do
          mock_shift.should_receive(:update_attributes).
            with("these" => :params, "section_ids" => [mock_section.id])
          put :update, :section_id => mock_section.id, :id => mock_shift.id,
            :shift => { :these => :params }
        end

        it { assigns(:shift).should eq(mock_shift) }
      end

      context "with valid parameters" do

        before(:each) do
          mock_shift.stub!(:update_attributes) { true }
          put :update, :section_id => mock_section.id, :id => mock_shift.id
        end

        it { should redirect_to(section_shifts_path(@section)) }

        it { flash[:notice].should eq("Successfully updated shift") }
      end

      context "with invalid parameters" do

        before(:each) do
          mock_shift.stub!(:update_attributes) { false }
          put :update, :section_id => mock_section.id, :id => mock_shift.id
        end

        it { should render_template(:edit) }

        it { flash[:error].should match(/Unable to update shift/) }
      end
    end

    context "the requested shift is not found" do

      before(:each) do
        mock_shifts.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        put :update, :section_id => mock_section.id, :id => mock_shift.id
      end

      it { flash[:error].should == "Error: requested shift not found" }

      it { should redirect_to(section_shifts_path(mock_section)) }
    end
  end
end
