require 'spec_helper'

describe VacationShiftsController do

  def mock_vacation_shift(stubs={})
    (@mock_vacation_shift ||= mock_model(VacationShift).as_null_object).tap do |vacation_shift|
      vacation_shift.stub(stubs) unless stubs.empty?
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
      VacationShift.should_receive(:new) { mock_vacation_shift }
      get :new, :section_id => mock_section.id
    end

    it { assigns(:vacation_shift).should eq(mock_vacation_shift) }
  end

  describe "POST create" do

    before(:each) do
      @section_vacation_shifts = stub("vacation_shifts", :<< => nil)
      mock_section.stub!(:vacation_shifts) { @section_vacation_shifts }
      VacationShift.stub!(:new) { mock_vacation_shift } 
    end

    context "always" do

      before(:each) do
        VacationShift.should_receive(:new).with("these" => "params") { mock_vacation_shift }
        post :create, :section_id => mock_section.id,
          :vacation_shift => { :these => :params }
      end

      it { assigns(:vacation_shift).should eq(mock_vacation_shift) }
    end

    context "with valid parameters" do

      before(:each) do
        @section_vacation_shifts.should_receive(:<<).with(mock_vacation_shift) { true }
        post :create, :section_id => mock_section.id
      end

      it { should redirect_to(section_shifts_path(mock_section)) }

      it { flash[:notice].should eq("Successfully created vacation shift") }
    end

    context "with invalid parameters" do

      before(:each) do
        @section_vacation_shifts.should_receive(:<<).with(mock_vacation_shift) { false }
        post :create, :section_id => mock_section.id
      end

      it { should render_template(:new) }

      it { flash[:error].should match(/Unable to create vacation shift/) }
    end
  end

  describe "GET edit" do

    let(:mock_vacation_shifts) { mock("vacation_shifts") }

    before(:each) do
      mock_section.stub!(:vacation_shifts) { mock_vacation_shifts }
    end

    context "the requested vacation_shift is found" do

      before(:each) do
        mock_vacation_shifts.stub!(:find).with(mock_vacation_shift.id.to_s) { mock_vacation_shift }
        get :edit, :section_id => mock_section.id, :id => mock_vacation_shift.id
      end

      it { assigns(:vacation_shift).should eq(mock_vacation_shift) }

      it { should render_template(:edit) }
    end

    context "the requested vacation_shift is not found" do

      before(:each) do
        mock_vacation_shifts.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        get :edit, :section_id => mock_section.id, :id => mock_vacation_shift.id
      end

      it { flash[:error].should == "Error: requested vacation shift not found" }

      it { should redirect_to(section_shifts_path(mock_section)) }
    end
  end

  describe "PUT update" do

    let(:mock_vacation_shifts) { mock("vacation_shifts") }

    before(:each) do
      mock_section.stub_chain("vacation_shifts.readonly") { mock_vacation_shifts }
    end

    context "the requested vacation_shift is found" do

      before(:each) do
        mock_vacation_shifts.stub!(:find).with(mock_vacation_shift.id.to_s) { mock_vacation_shift }
      end

      context "always" do

        before(:each) do
          mock_vacation_shift.should_receive(:update_attributes).
            with("these" => "params", "section_ids" => [mock_section.id])
          put :update, :section_id => mock_section.id, :id => mock_vacation_shift.id,
            :vacation_shift => { :these => :params }
        end

        it { assigns(:vacation_shift).should eq(mock_vacation_shift) }
      end

      context "with valid parameters" do

        before(:each) do
          mock_vacation_shift.stub!(:update_attributes) { true }
          put :update, :section_id => mock_section.id, :id => mock_vacation_shift.id
        end

        it { should redirect_to(section_shifts_path(@section)) }

        it { flash[:notice].should eq("Successfully updated vacation shift") }
      end

      context "with invalid parameters" do

        before(:each) do
          mock_vacation_shift.stub!(:update_attributes) { false }
          put :update, :section_id => mock_section.id, :id => mock_vacation_shift.id
        end

        it { should render_template(:edit) }

        it { flash[:error].should match(/Unable to update vacation shift/) }
      end
    end

    context "the requested vacation_shift is not found" do

      before(:each) do
        mock_vacation_shifts.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        put :update, :section_id => mock_section.id, :id => mock_vacation_shift.id
      end

      it { flash[:error].should == "Error: requested vacation shift not found" }

      it { should redirect_to(section_shifts_path(mock_section)) }
    end
  end
end
