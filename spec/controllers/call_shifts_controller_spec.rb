require 'spec_helper'

describe CallShiftsController do

  def mock_call_shift(stubs={})
    (@mock_call_shift ||= mock_model(CallShift).as_null_object).tap do |call_shift|
      call_shift.stub(stubs) unless stubs.empty?
    end
  end

  let(:mock_section) { mock_model(Section) }

  before(:each) do
    Section.stub!(:find).with(mock_section.id.to_s) { mock_section }
    controller.should_receive(:authenticate_user!)
    controller.should_receive(:authorize!).with(:manage, mock_section)
  end

  describe "GET new" do

    before(:each) do
      CallShift.should_receive(:new) { mock_call_shift }
      get :new, :section_id => mock_section.id
    end

    it { assigns(:call_shift).should eq(mock_call_shift) }
  end

  describe "POST create" do

    before(:each) do
      @section_call_shifts = stub("call_shifts", :<< => nil)
      mock_section.stub!(:call_shifts) { @section_call_shifts }
      CallShift.stub!(:new) { mock_call_shift } 
    end

    context "always" do

      before(:each) do
        CallShift.should_receive(:new).with("these" => "params") { mock_call_shift }
        post :create, :section_id => mock_section.id,
          :call_shift => { :these => :params }
      end

      it { assigns(:call_shift).should eq(mock_call_shift) }
    end

    context "with valid parameters" do

      before(:each) do
        @section_call_shifts.should_receive(:<<).with(mock_call_shift) { true }
        post :create, :section_id => mock_section.id
      end

      it { should redirect_to(section_shifts_path(mock_section)) }

      it { flash[:notice].should eq("Successfully created call shift") }
    end

    context "with invalid parameters" do

      before(:each) do
        @section_call_shifts.should_receive(:<<).with(mock_call_shift) { false }
        post :create, :section_id => mock_section.id
      end

      it { should render_template(:new) }

      it { flash[:error].should match(/Unable to create call shift/) }
    end
  end

  describe "GET edit" do

    let(:mock_call_shifts) { mock("call_shifts") }

    before(:each) do
      mock_section.stub!(:call_shifts) { mock_call_shifts }
    end

    context "the requested call_shift is found" do

      before(:each) do
        mock_call_shifts.stub!(:find).with(mock_call_shift.id.to_s) { mock_call_shift }
        get :edit, :section_id => mock_section.id, :id => mock_call_shift.id
      end

      it { assigns(:call_shift).should eq(mock_call_shift) }

      it { should render_template(:edit) }
    end

    context "the requested call_shift is not found" do

      before(:each) do
        mock_call_shifts.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        get :edit, :section_id => mock_section.id, :id => mock_call_shift.id
      end

      it { flash[:error].should == "Error: requested call shift not found" }

      it { should redirect_to(section_shifts_path(mock_section)) }
    end
  end

  describe "PUT update" do

    let(:mock_call_shifts) { mock("call_shifts") }

    before(:each) do
      mock_section.stub_chain("call_shifts.readonly") { mock_call_shifts }
    end

    context "the requested call_shift is found" do

      before(:each) do
        mock_call_shifts.stub!(:find).with(mock_call_shift.id.to_s) { mock_call_shift }
      end

      context "always" do

        before(:each) do
          mock_call_shift.should_receive(:update_attributes).
            with("these" => "params", "section_ids" => [mock_section.id])
          put :update, :section_id => mock_section.id, :id => mock_call_shift.id,
            :call_shift => { :these => :params }
        end

        it { assigns(:call_shift).should eq(mock_call_shift) }
      end

      context "with valid parameters" do

        before(:each) do
          mock_call_shift.stub!(:update_attributes) { true }
          put :update, :section_id => mock_section.id, :id => mock_call_shift.id
        end

        it { should redirect_to(section_shifts_path(@section)) }

        it { flash[:notice].should eq("Successfully updated call shift") }
      end

      context "with invalid parameters" do

        before(:each) do
          mock_call_shift.stub!(:update_attributes) { false }
          put :update, :section_id => mock_section.id, :id => mock_call_shift.id
        end

        it { should render_template(:edit) }

        it { flash[:error].should match(/Unable to update call shift/) }
      end
    end

    context "the requested call_shift is not found" do

      before(:each) do
        mock_call_shifts.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        put :update, :section_id => mock_section.id, :id => mock_call_shift.id
      end

      it { flash[:error].should == "Error: requested call shift not found" }

      it { should redirect_to(section_shifts_path(mock_section)) }
    end
  end
end
