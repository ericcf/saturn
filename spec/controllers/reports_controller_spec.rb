require 'spec_helper'

describe ReportsController do

  def mock_section(stubs={})
    (@mock_section ||= stub_model(Section)).tap do |section|
      section.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET shift_totals" do

    before(:each) do
      mock_physician = stub_model(Physician)
      mock_shift = stub_model(Shift)
      Shift.stub!(:find) { [mock_shift] }
      mock_section(:members_by_group => {"Group A" => [mock_physician]},
        :shift_tags => [stub_model(ShiftTag, :shift_ids => [mock_shift.id])])
      mock_section.stub!(:active_shifts) { [mock_shift] }
      Section.stub!(:find).with(mock_section.id) { mock_section }
      mock_schedule = stub_model(WeeklySchedule, :dates => [Date.today])
      mock_section.stub_chain("weekly_schedules.published.include_dates").
        and_return([mock_schedule])
      mock_section.stub_chain("assignments.where").
        and_return([stub_model(Assignment, :fixed_duration => 0.0, :physician_id => mock_physician.id, :shift_id => mock_shift.id)])
    end

    context "always" do

      before(:each) do
        get :shift_totals, :section_id => mock_section.id
      end

      it { assigns(:start_date).should == Date.today.at_beginning_of_month }

      it { assigns(:end_date).should == Date.today }
    end
  end

  describe "GET search_shift_totals" do

    let(:mock_report) { mock_model(ShiftTotalsReport) }

    before(:each) do
      Section.stub!(:find).with(mock_section.id) { mock_section }
      ShiftTotalsReport.stub!(:new) { mock_report }
      get :search_shift_totals, :section_id => mock_section.id
    end

    it { assigns(:shift_totals_report).should eq(mock_report) }
  end

  describe "GET shift_totals_report" do

    let(:mock_report) { mock_model(ShiftTotalsReport) }

    before(:each) do
      Section.stub!(:find).with(mock_section.id) { mock_section }
      ShiftTotalsReport.stub!(:new) { mock_report }
      mock_report.stub!(:section=)
    end

    context "always" do

      before(:each) do
        ShiftTotalsReport.should_receive(:new).with("these" => :params).
          and_return(mock_report)
        mock_report.should_receive(:section=).with(mock_section)
        get :shift_totals_report, :section_id => mock_section.id,
          :shift_totals_report => { :these => :params }
      end

      it { assigns(:shift_totals_report).should eq(mock_report) }
    end

    context "with a valid query" do

      before(:each) do
        mock_report.stub!(:valid?) { true }
        get :shift_totals_report, :section_id => mock_section.id
      end

      it { should render_template(:shift_totals_report) }
    end

    context "with an invalid query" do

      before(:each) do
        mock_report.stub!(:valid?) { false }
        get :shift_totals_report, :section_id => mock_section.id
      end

      it { should render_template(:search_shift_totals) }
    end
  end

  describe "GET shift_totals_by_day" do

    let(:mock_report) { mock_model(ShiftTotalsReport) }

    let(:mock_shift) { stub_model(Shift) }

    before(:each) do
      Section.stub!(:find).with(mock_section.id) { mock_section }
      ShiftTotalsReport.stub!(:new) { mock_report }
      mock_report.stub!(:section=)
      Shift.stub!(:find).with(mock_shift.id) { mock_shift }
      get :shift_totals_by_day, :section_id => mock_section.id,
        :shift_id => mock_shift.id
    end

    it { assigns(:shift_totals_report).should eq(mock_report) }

    it { assigns(:shift).should eq(mock_shift) }
  end

  describe "GET section_physician_shift_totals" do

    before(:each) do
      Section.stub!(:find).with(mock_section.id) { mock_section }
      @mock_physician = mock_model(Physician)
      mock_section.stub_chain("members.find") { @mock_physician }
      get :section_physician_shift_totals, :section_id => mock_section.id,
        :physician_id => @mock_physician.id
    end

    it { assigns(:start_date).should == Date.today.at_beginning_of_month }
  end
end
