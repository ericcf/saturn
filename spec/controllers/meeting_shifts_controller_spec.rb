require 'spec_helper'

describe MeetingShiftsController do

  def mock_meeting_shift(stubs={})
    (@mock_meeting_shift ||= mock_model(MeetingShift).as_null_object).tap do |meeting_shift|
      meeting_shift.stub(stubs) unless stubs.empty?
    end
  end

  let(:mock_section) { mock_model(Section) }

  before(:each) do
    Section.stub!(:find).with(mock_section.id) { mock_section }
    controller.should_receive(:authenticate_user!)
    controller.should_receive(:authorize!).with(:manage, mock_section)
  end

  describe "GET new" do

    before(:each) do
      MeetingShift.should_receive(:new) { mock_meeting_shift }
      get :new, :section_id => mock_section.id
    end

    it { assigns(:meeting_shift).should eq(mock_meeting_shift) }
  end

  describe "POST create" do

    before(:each) do
      @section_meeting_shifts = stub("meeting_shifts", :<< => nil)
      mock_section.stub!(:meeting_shifts) { @section_meeting_shifts }
      MeetingShift.stub!(:new) { mock_meeting_shift } 
    end

    context "always" do

      before(:each) do
        MeetingShift.should_receive(:new).with("these" => :params) { mock_meeting_shift }
        post :create, :section_id => mock_section.id,
          :meeting_shift => { :these => :params }
      end

      it { assigns(:meeting_shift).should eq(mock_meeting_shift) }
    end

    context "with valid parameters" do

      before(:each) do
        @section_meeting_shifts.should_receive(:<<).with(mock_meeting_shift) { true }
        post :create, :section_id => mock_section.id
      end

      it { should redirect_to(section_shifts_path(mock_section)) }

      it { flash[:notice].should eq("Successfully created meeting shift") }
    end

    context "with invalid parameters" do

      before(:each) do
        @section_meeting_shifts.should_receive(:<<).with(mock_meeting_shift) { false }
        post :create, :section_id => mock_section.id
      end

      it { should render_template(:new) }

      it { flash[:error].should match(/Unable to create meeting shift/) }
    end
  end

  describe "GET edit" do

    let(:mock_meeting_shifts) { mock("meeting_shifts") }

    before(:each) do
      mock_section.stub!(:meeting_shifts) { mock_meeting_shifts }
    end

    context "the requested meeting_shift is found" do

      before(:each) do
        mock_meeting_shifts.stub!(:find).with(mock_meeting_shift.id) { mock_meeting_shift }
        get :edit, :section_id => mock_section.id, :id => mock_meeting_shift.id
      end

      it { assigns(:meeting_shift).should eq(mock_meeting_shift) }

      it { should render_template(:edit) }
    end

    context "the requested meeting_shift is not found" do

      before(:each) do
        mock_meeting_shifts.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        get :edit, :section_id => mock_section.id, :id => mock_meeting_shift.id
      end

      it { flash[:error].should == "Error: requested meeting shift not found" }

      it { should redirect_to(section_shifts_path(mock_section)) }
    end
  end

  describe "PUT update" do

    let(:mock_meeting_shifts) { mock("meeting_shifts") }

    before(:each) do
      mock_section.stub_chain("meeting_shifts.readonly") { mock_meeting_shifts }
    end

    context "the requested meeting_shift is found" do

      before(:each) do
        mock_meeting_shifts.stub!(:find).with(mock_meeting_shift.id) { mock_meeting_shift }
      end

      context "always" do

        before(:each) do
          mock_meeting_shift.should_receive(:update_attributes).
            with("these" => :params, "section_ids" => [mock_section.id])
          put :update, :section_id => mock_section.id, :id => mock_meeting_shift.id,
            :meeting_shift => { :these => :params }
        end

        it { assigns(:meeting_shift).should eq(mock_meeting_shift) }
      end

      context "with valid parameters" do

        before(:each) do
          mock_meeting_shift.stub!(:update_attributes) { true }
          put :update, :section_id => mock_section.id, :id => mock_meeting_shift.id
        end

        it { should redirect_to(section_shifts_path(@section)) }

        it { flash[:notice].should eq("Successfully updated meeting shift") }
      end

      context "with invalid parameters" do

        before(:each) do
          mock_meeting_shift.stub!(:update_attributes) { false }
          put :update, :section_id => mock_section.id, :id => mock_meeting_shift.id
        end

        it { should render_template(:edit) }

        it { flash[:error].should match(/Unable to update meeting shift/) }
      end
    end

    context "the requested meeting_shift is not found" do

      before(:each) do
        mock_meeting_shifts.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        put :update, :section_id => mock_section.id, :id => mock_meeting_shift.id
      end

      it { flash[:error].should == "Error: requested meeting shift not found" }

      it { should redirect_to(section_shifts_path(mock_section)) }
    end
  end
end
