require 'spec_helper'

describe AdminsController do

  before(:each) do
    @mock_section = stub_model(Section)
    Section.stub!(:find) { @mock_section }
    @mock_user = stub_model(Deadbolt::User)
    Deadbolt::User.stub!(:all) { [@mock_user] }
    controller.should_receive(:authenticate_user!)
    controller.should_receive(:authorize!).with(:manage, @mock_section)
  end

  describe "GET 'show'" do

    before(:each) do
      @mock_section.stub!(:create_admin_role)
      get :show, :section_id => @mock_section.id
    end

    it { should render_template("show") }

    it { assigns(:users).should eq([@mock_user]) }
  end

  describe "PUT 'update'" do

    before(:each) do
      @mock_user = stub_model(Deadbolt::User)
    end

    it "updates the section with administrator ids" do
      @mock_section.should_receive(:update_attributes).
        with(:administrator_ids => ["1"])
      put :update, :section_id => @mock_section.id,
        :admin_ids => { "1" => "true" }
    end

    it "redirects to show" do
      put :update, :section_id => @mock_section.id
      response.should redirect_to(section_admins_path(@mock_section))
    end
  end
end
