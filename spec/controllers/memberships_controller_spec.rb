require 'spec_helper'

describe MembershipsController do

  def mock_membership(stubs={})
    @mock_membership ||= mock_model(SectionMembership, stubs).as_null_object
  end

  before(:each) do
    @mock_section = mock_model(Section, :memberships => [mock_membership])
    Section.stub!(:find).with(@mock_section.id).and_return(@mock_section)
    controller.should_receive(:authenticate_user!)
    controller.should_receive(:authorize!).with(:manage, SectionMembership)
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
      Group.stub!(:find_all_by_title).and_return([mock_model(Group)])
      @mock_person = mock_model(Person, :section_ids => [], :member_of_group? => true)
      Person.stub_chain(:current, :includes).and_return([@mock_person])
      get :new, :section_id => @mock_section.id
    end

    it { assigns(:people).should eq([@mock_person]) }
  end
end
