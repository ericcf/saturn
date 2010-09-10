require 'spec_helper'

describe MembershipsController do

  def mock_membership(stubs={})
    @mock_membership ||= mock_model(SectionMembership, stubs).as_null_object
  end

  before(:each) do
    @mock_section = mock_model(Section, :memberships => [mock_membership])
    Section.stub!(:find).with(@mock_section.id).and_return(@mock_section)
  end

  describe "GET new" do

    before(:each) do
      SectionMembership.should_receive(:new).and_return(mock_membership)
      get :new, :section_id => @mock_section.id
    end

    it { assigns(:membership).should eq(mock_membership) }
  end

  describe "POST create" do

    before(:each) do
      @section_memberships = stub("memberships", :<< => nil)
      @mock_section.stub!(:memberships).and_return(@section_memberships)
      SectionMembership.stub!(:new).and_return(mock_membership)
    end

    context "always" do

      before(:each) do
        SectionMembership.should_receive(:new).
          with("these" => :params).
          and_return(mock_membership)
        post :create, :section_id => @mock_section.id,
          :section_membership => { :these => :params }
      end

      it { assigns(:membership).should eq(mock_membership) }
    end

    context "with valid parameters" do

      before(:each) do
        @section_memberships.should_receive(:<<).with(mock_membership).
          and_return(true)
        post :create, :section_id => @mock_section.id
      end

      it { should redirect_to(section_path(@mock_section)) }
    end

    context "with invalid parameters" do

      before(:each) do
        @section_memberships.should_receive(:<<).with(mock_membership).
          and_return(false)
        post :create, :section_id => @mock_section.id
      end

      it { should render_template(:new) }
    end
  end
end
