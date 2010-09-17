require 'spec_helper'

describe UsersController do

  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs)
  end

  describe "GET 'index'" do

    before(:each) do
      User.stub!(:all).and_return([mock_user])
      get :index
    end

    it { assigns(:users).should eq([mock_user]) }
  end

  describe "PUT 'update_roles'" do

    before(:each) do
      User.stub!(:exists?).with(mock_user.id).and_return(true)
      User.stub!(:find).with(mock_user.id).and_return(mock_user)
    end

    context "when updating admin attribute" do

      it "updates the user" do
        mock_user.should_receive(:update_attribute).with(:admin, :foo)
        put :update_roles, :users => { mock_user.id => { :admin => :foo } }
      end
    end
  end
end
