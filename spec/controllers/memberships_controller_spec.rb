require 'spec_helper'

describe MembershipsController do

  def mock_membership(stubs={})
    @mock_membership ||= mock_model(SectionMembership, stubs).as_null_object
  end

  before(:each) do
    @mock_section = mock_model(Section, :memberships => [mock_membership])
    Section.stub!(:find).with(@mock_section.id).and_return(@mock_section)
    controller.should_receive(:authenticate_user!)
  end

  describe "GET index" do

    before(:each) do
      @mock_members_by_group = mock("members by group")
      @mock_section.stub!(:members_by_group).and_return(@mock_members_by_group)
      get :index, :section_id => @mock_section.id
    end

    it { assigns(:members_by_group).should eq(@mock_members_by_group) }
  end

  describe "GET new" do

    before(:each) do
      SectionMembership.should_receive(:new).and_return(mock_membership)
      get :new, :section_id => @mock_section.id
    end

    it { assigns(:membership).should eq(mock_membership) }
  end
end
