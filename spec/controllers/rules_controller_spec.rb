require 'spec_helper'

describe RulesController do

  def mock_weekly_duration_rule(stubs={})
    (@mock_weekly_duration_rule ||= mock_model(WeeklyShiftDurationRule).as_null_object).tap do |rule|
      rule.stub(stubs) unless stubs.empty?
    end
  end

  def mock_daily_count_rule(stubs={})
    (@mock_daily_count_rule ||= mock_model(DailyShiftCountRule).as_null_object).tap do |rule|
      rule.stub(stubs) unless stubs.empty?
    end
  end

  before(:each) do
    @mock_section = stub_model(Section)
    Section.stub!(:find).with(@mock_section.id.to_s).and_return(@mock_section)
  end

  describe "GET 'show'" do

    it "assigns weekly shift duration rule to @weekly_shift_duration_rule" do
      @mock_section.stub!(:weekly_shift_duration_rule).
        and_return(mock_weekly_duration_rule)
      get :show, :section_id => @mock_section.id
      assigns(:weekly_shift_duration_rule).should eq(mock_weekly_duration_rule)
    end

    it "assigns daily shift count rules to @daily_shift_count_rules" do
      @mock_section.stub!(:daily_shift_count_rules).
        and_return([mock_daily_count_rule])
      get :show, :section_id => @mock_section.id
      assigns(:daily_shift_count_rules).should eq([mock_daily_count_rule])
    end
  end

  describe "GET 'edit'" do

    context "there is a weekly shift duration rule" do

      it "assigns the rule to @weekly_shift_duration_rule" do
        @mock_section.stub!(:weekly_shift_duration_rule).
          and_return(mock_weekly_duration_rule)
        get :edit, :section_id => @mock_section.id
        assigns(:weekly_shift_duration_rule).
          should eq(mock_weekly_duration_rule)
      end
    end

    context "there is not a weekly shift duration rule" do

      it "assigns a new rule to @weekly_shift_duration_rule" do
        @mock_section.stub!(:weekly_shift_duration_rule)
        @mock_section.stub!(:build_weekly_shift_duration_rule).
          and_return(mock_weekly_duration_rule)
        get :edit, :section_id => @mock_section.id
        assigns(:weekly_shift_duration_rule).
          should eq(mock_weekly_duration_rule)
      end
    end

    context "there is a daily shift count rule for a shift tag" do

      it "assigns the rule to @daily_shift_count_rules" do
        mock_shift_tag = stub_model(ShiftTag,
          :daily_shift_count_rule => mock_daily_count_rule)
        @mock_section.stub_chain(:shift_tags, :includes).
          and_return([mock_shift_tag])
        get :edit, :section_id => @mock_section.id
        assigns(:daily_shift_count_rules).should include(mock_daily_count_rule)
      end
    end

    context "there is not a daily shift count rule for a shift tag" do

      it "assigns a new rule to @daily_shift_count_rules" do
        mock_shift_tag = stub_model(ShiftTag,
          :daily_shift_count_rule => nil,
          :build_daily_shift_count_rule => mock_daily_count_rule)
        @mock_section.stub_chain(:shift_tags, :includes).
          and_return([mock_shift_tag])
        get :edit, :section_id => @mock_section.id
        assigns(:daily_shift_count_rules).should include(mock_daily_count_rule)
      end
    end
  end

  describe "PUT 'update'" do

    context "is successful" do

      before(:each) do
        @mock_section.should_receive(:update_attributes).and_return(true)
        put :update, :section_id => @mock_section.id
      end

      it { should redirect_to(section_rules_path(@mock_section)) }

      it { flash[:notice].should eq("Successfully updated rules") }
    end

    context "is not successful" do

      before(:each) do
        @mock_section.should_receive(:update_attributes).and_return(false)
        put :update, :section_id => @mock_section.id
      end

      it { should render_template(:edit) }

      it { flash[:error].should match(/Unable to update rules/) }
    end

    context "always" do

      it "updates the section with the specified attributes" do
        @mock_section.should_receive(:update_attributes).
          with("these" => "params")
        put :update, :section_id => @mock_section.id, :section => { :these => :params }
      end
    end
  end
end
