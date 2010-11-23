require 'spec_helper'

describe SectionsController do

  def mock_section(stubs={})
    (@mock_section ||= mock_model(Section).as_null_object).tap do |section|
      section.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do

    before(:each) do
      Section.should_receive(:all).and_return([mock_section])
      get :index
    end

    it { assigns(:sections).should eq([mock_section]) }
  end

  describe "GET new" do

    before(:each) do
      Section.should_receive(:new).and_return(mock_section)
      controller.should_receive(:authenticate_user!)
      controller.should_receive(:authorize!).with(:create, mock_section)
      get :new
    end

    it { assigns(:section).should eq(mock_section) }
  end

  describe "POST create" do
    
    before(:each) do
      controller.should_receive(:authenticate_user!)
    end

    context "always" do

      before(:each) do
        Section.should_receive(:new).
          with("these" => :params).
          and_return(mock_section)
        controller.should_receive(:authorize!).with(:create, mock_section)
        post :create, :section => { :these => :params }
      end

      it { assigns(:section).should eq(mock_section) }
    end

    context "with valid parameters" do

      before(:each) do
        Section.should_receive(:new).
          and_return(mock_section(:save => true))
        controller.should_receive(:authorize!).with(:create, mock_section)
        post :create
      end

      it { should redirect_to(section_memberships_path(mock_section)) }

      it { flash[:notice].should eq("Successfully created section") }
    end

    context "with invalid parameters" do

      before(:each) do
        Section.should_receive(:new).
          and_return(mock_section(:save => false))
        controller.should_receive(:authorize!).with(:create, mock_section)
        post :create
      end

      it { should render_template(:new) }
    end
  end

  describe "GET edit" do

    before(:each) do
      controller.should_receive(:authenticate_user!)
    end

    context "the requested section is found" do

      before(:each) do
        Section.should_receive(:find).with(mock_section.id).
          and_return(mock_section)
        controller.should_receive(:authorize!).with(:update, mock_section)
        get :edit, :id => mock_section.id
      end

      it { assigns(:section).should eq(mock_section) }

      it { should render_template(:edit) }
    end

    context "the requested section is not found" do

      before(:each) do
        Section.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        get :edit, :id => 1
      end

      it { flash[:error].should == "Error: requested section not found" }

      it { should redirect_to(sections_path) }
    end
  end

  describe "PUT update" do

    before(:each) do
      controller.should_receive(:authenticate_user!)
    end

    context "the requested section is found" do

      context "always" do

        before(:each) do
          mock_section.should_receive(:update_attributes).
            with("these" => :params)
          Section.should_receive(:find).
            with(mock_section.id).
            and_return(mock_section)
          controller.should_receive(:authorize!).with(:update, mock_section)
          put :update, :id => mock_section.id, :section => { :these => :params }
        end

        it { assigns(:section).should eq(mock_section) }
      end

      context "with valid parameters" do

        before(:each) do
          Section.stub!(:find).
            and_return(mock_section(:update_attributes => true))
          controller.should_receive(:authorize!).with(:update, mock_section)
        end

        context "and no 'redirect_path' parameter" do

          before(:each) do
            put :update, :id => mock_section.id
          end

          it { should redirect_to(section_memberships_path(mock_section)) }

          it { flash[:notice].should eq("Successfully updated section") }
        end

        context "and a 'redirect_path' parameter" do

          before(:each) do
            put :update, :id => mock_section.id, :redirect_path => "/foo"
          end

          it { should redirect_to("/foo") }
        end
      end

      context "with invalid parameters" do

        before(:each) do
          Section.stub!(:find).
            and_return(mock_section(:update_attributes => false))
          controller.should_receive(:authorize!).with(:update, mock_section)
          put :update, :id => mock_section.id
        end

        it { should render_template(:edit) }

        it { flash[:error].should match(/Error: could not complete changes/) }
      end
    end

    context "the requested section is not found" do

      before(:each) do
        Section.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        put :update, :id => 1
      end

      it { flash[:error].should == "Error: requested section not found" }

      it { should redirect_to(sections_path) }
    end
  end

  describe "DELETE destroy" do

    before(:each) do
      controller.should_receive(:authenticate_user!)
    end

    context "the requested section is found" do

      before(:each) do
        Section.should_receive(:find).with(mock_section.id).
          and_return(mock_section)
        controller.should_receive(:authorize!).with(:destroy, mock_section)
      end

      context "the section is destroyed successfully" do

        before(:each) do
          mock_section.should_receive(:destroy).and_return(true)
          delete :destroy, :id => mock_section.id
        end

        it { flash[:notice].should == "Successfully deleted section" }

        it { should redirect_to(sections_path) }
      end

      context "the section is not destroyed successfully" do

        before(:each) do
          mock_section.should_receive(:destroy).and_return(false)
          delete :destroy, :id => mock_section.id
        end

        it { flash[:error].should == "Error: failed to delete section" }

        it { should redirect_to(sections_path) }
      end
    end

    context "the requested section is not found" do

      before(:each) do
        Section.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        delete :destroy, :id => 1
      end

      it { flash[:error].should == "Error: requested section not found" }

      it { should redirect_to(sections_path) }
    end
  end
end
