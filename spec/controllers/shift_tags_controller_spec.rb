require 'spec_helper'

describe ShiftTagsController do

  def mock_shift_tag(stubs={})
    @mock_shift_tag ||= mock_model(ShiftTag, stubs).as_null_object
  end

  before(:each) do
    @section_shift_tags = stub("shift_tags")
    @mock_section = mock_model(Section, :shift_tags => @section_shift_tags)
    Section.stub!(:find).with(@mock_section.id).
      and_return(@mock_section)
    controller.should_receive(:authenticate_user!)
  end

  describe "GET index" do

    before(:each) do
      get :index, :section_id => @mock_section.id
    end
    
    it { assigns(:shift_tags).should eq(@section_shift_tags) }
  end

  describe "GET show" do

    before(:each) do
      @mock_shift_tags = mock("shift_tags")
      @mock_section.stub!(:shift_tags).and_return(@mock_shift_tags)
    end

    context "the requested shift tag is found" do

      before(:each) do
        @mock_shift_tags.should_receive(:find).with(mock_shift_tag.id).
          and_return(mock_shift_tag)
        get :show, :section_id => @mock_section.id,
          :id => mock_shift_tag.id
      end

      it { assigns(:shift_tag).should eq(mock_shift_tag) }
    end

    context "the requested shift tag is not found" do

      before(:each) do
        @mock_shift_tags.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        get :show, :section_id => @mock_section.id, :id => 1
      end

      it { flash[:error].should == "Error: requested shift tag not found" }

      it { should redirect_to(section_shift_tags_path) }
    end
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

  describe "GET edit" do

    before(:each) do
      @mock_shift_tags = mock("shift_tags")
      @mock_section.stub!(:shift_tags).and_return(@mock_shift_tags)
    end

    context "the requested shift tag is found" do

      before(:each) do
        @mock_shift_tags.should_receive(:find).with(mock_shift_tag.id).
          and_return(mock_shift_tag)
        get :edit, :section_id => @mock_section.id,
          :id => mock_shift_tag.id
      end

      it { assigns(:shift_tag).should eq(mock_shift_tag) }

      it { should render_template(:edit) }
    end

    context "the requested shift tag is not found" do

      before(:each) do
        @mock_shift_tags.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        get :edit, :section_id => @mock_section.id, :id => 1
      end

      it { flash[:error].should == "Error: requested shift tag not found" }

      it { should redirect_to(section_shift_tags_path) }
    end
  end

  describe "PUT update" do

    before(:each) do
      @mock_shift_tags = mock("shift_tags")
      @mock_section.stub!(:shift_tags).and_return(@mock_shift_tags)
    end

    context "the requested shift tag is found" do

      context "always" do

        before(:each) do
          mock_shift_tag.should_receive(:update_attributes).
            with("these" => :params)
          @mock_shift_tags.should_receive(:find).with(mock_shift_tag.id).
            and_return(mock_shift_tag)
          put :update, :section_id => @mock_section.id,
            :id => mock_shift_tag.id, :shift_tag => { :these => :params }
        end

        it { assigns(:shift_tag).should eq(mock_shift_tag) }
      end

      context "with valid parameters" do

        before(:each) do
          @mock_shift_tags.stub!(:find).
            and_return(mock_shift_tag(:update_attributes => true))
          put :update, :section_id => @mock_section.id,
            :id => mock_shift_tag.id
        end

        it { should redirect_to(section_shift_tag_path(@mock_section, mock_shift_tag)) }
      end

      context "with invalid parameters" do

        before(:each) do
          @mock_shift_tags.stub!(:find).
            and_return(mock_shift_tag(:update_attributes => false))
          put :update, :section_id => @mock_section.id,
            :id => mock_shift_tag.id
        end

        it { should render_template(:edit) }
      end
    end

    context "the requested shift tag is not found" do

      before(:each) do
        @mock_shift_tags.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        put :update, :section_id => @mock_section.id,
          :id => mock_shift_tag.id
      end

      it { flash[:error].should == "Error: requested shift tag not found" }

      it { should redirect_to(section_shift_tags_path(@mock_section)) }
    end
  end

  describe "DELETE destroy" do

    before(:each) do
      @mock_shift_tags = mock("shift_tags")
      @mock_section.stub!(:shift_tags).and_return(@mock_shift_tags)
    end

    context "the requested shift tag is found" do

      before(:each) do
        @mock_shift_tags.stub!(:find).with(mock_shift_tag.id).
          and_return(mock_shift_tag)
      end

      context "and destroyed successfully" do

        before(:each) do
          mock_shift_tag.should_receive(:destroy).and_return(true)
          delete :destroy, :section_id => @mock_section.id,
            :id => mock_shift_tag.id
        end

        it { flash[:notice].should == "Successfully deleted shift tag" }

        it { should redirect_to(section_shift_tags_path(@mock_section)) }
      end

      context "and not destroyed successfully" do

        before(:each) do
          mock_shift_tag.should_receive(:destroy).and_return(false)
          delete :destroy, :section_id => @mock_section.id,
            :id => mock_shift_tag.id
        end

        it { flash[:error].should == "Error: failed to delete shift tag" }

        it { should redirect_to(section_shift_tags_path(@mock_section)) }
      end
    end

    context "the requested shift tag is not found" do

      before(:each) do
        @mock_shift_tags.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        delete :destroy, :section_id => @mock_section.id,
          :id => mock_shift_tag.id
      end

      it { flash[:error].should == "Error: requested shift tag not found" }

      it { should redirect_to(section_shift_tags_path(@mock_section)) }
    end
  end
end
