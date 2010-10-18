require 'spec_helper'

describe ShiftTagsController do

  def mock_shift_tag(stubs={})
    @mock_shift_tag ||= mock_model(ShiftTag, stubs).as_null_object
  end

  before(:each) do
    @section_shift_tags = stub("shift_tags")
    @mock_section = mock_model(Section, :shift_tags => @section_shift_tags)
    Section.stub!(:find).with(@mock_section.id).and_return(@mock_section)
    controller.should_receive(:authenticate_user!)
    controller.should_receive(:authorize!).with(:manage, @mock_section)
  end

  describe "GET index" do

    before(:each) do
      get :index, :section_id => @mock_section.id
    end
    
    it { assigns(:shift_tags).should eq(@section_shift_tags) }
  end

  describe "GET new" do

    before(:each) do
      ShiftTag.should_receive(:new).and_return(mock_shift_tag)
      get :new, :section_id => @mock_section.id
    end

    it { assigns(:shift_tag).should eq(mock_shift_tag) }
  end

  describe "POST create" do

    before(:each) do
      @section_shift_tags = stub("shift_tags", :<< => nil)
      @mock_section.stub!(:shift_tags).and_return(@section_shift_tags)
      ShiftTag.stub!(:new).and_return(mock_shift_tag)
    end

    context "always" do

      before(:each) do
        ShiftTag.should_receive(:new).
          with("these" => :params).
          and_return(mock_shift_tag)
        post :create, :section_id => @mock_section.id,
          :shift_tag => { :these => :params }
      end

      it { assigns(:shift_tag).should eq(mock_shift_tag) }
    end

    context "with valid parameters" do

      before(:each) do
        @section_shift_tags.should_receive(:<<).with(mock_shift_tag).and_return(true)
        post :create, :section_id => @mock_section.id
      end

      it { should redirect_to(section_shift_tags_path(@mock_section)) }
    end

    context "with invalid parameters" do

      before(:each) do
        @section_shift_tags.should_receive(:<<).with(mock_shift_tag).and_return(false)
        post :create, :section_id => @mock_section.id
      end

      it { should render_template(:new) }

      it { flash[:error].should match(/Error: could not create category/) }
    end
  end

  describe "GET search" do

    before(:each) do
      @mock_section.stub_chain(:shift_tags, :title_like).and_return([])
      get :search, :section_id => @mock_section.id
    end

    it { should respond_with_content_type(:json) }
  end
end
