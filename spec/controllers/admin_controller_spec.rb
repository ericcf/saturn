require 'spec_helper'

describe AdminController do

  before(:each) do
    controller.should_receive(:authenticate_user!)
  end

  describe "GET index" do

    before(:each) do
      get :index
    end

    it { should render_template(:index) }
  end
end
