require 'spec_helper'

describe PhysicianAliasesController do

  def mock_alias(stubs={})
    (@mock_alias ||= stub_model(PhysicianAlias)).tap do |p_alias|
      p_alias.stub(stubs) unless stubs.empty?
    end
  end

  before(:each) do
    @mock_physician = mock_model(Physician, :physician_aliases => [mock_alias])
    Physician.stub!(:find).with(@mock_physician.id).and_return(@mock_physician)
    controller.should_receive(:authenticate_user!)
  end

  describe "GET new" do

    before(:each) do
      PhysicianAlias.should_receive(:new).and_return(mock_alias)
      get :new, :physician_id => @mock_physician.id
    end

    it { assigns(:physician_alias).should eq(mock_alias) }

    it { should render_template(:new) }
  end

  describe "POST create" do

    before(:each) do
      @mock_physician.stub!(:build_names_alias).
        and_return(mock_alias)
    end

    context "always" do

      before(:each) do
        @mock_physician.should_receive(:build_names_alias).
          with("these" => :params).
          and_return(mock_alias)
        post :create, :physician_id => @mock_physician.id,
          :physician_alias => { :these => :params }
      end

      it { assigns(:physician_alias).should eq(mock_alias) }
    end

    context "with valid parameters" do

      before(:each) do
        mock_alias.should_receive(:save).and_return(true)
        post :create, :physician_id => @mock_physician.id
      end

      it { should redirect_to(physicians_path) }

      it { flash[:notice].should eq("Successfully created alias") }
    end

    context "with invalid parameters" do

      before(:each) do
        mock_alias.should_receive(:save).and_return(false)
        post :create, :physician_id => @mock_physician.id
      end

      it { should render_template(:new) }
    end
  end

  describe "GET edit" do

    before(:each) do
      @mock_physician.stub!(:names_alias).and_return(mock_alias)
      get :edit, :physician_id => @mock_physician.id
    end

    it { assigns(:physician_alias).should eq(mock_alias) }

    it { should render_template(:edit) }
  end

  describe "PUT update" do

    before(:each) do
      @mock_physician.stub!(:names_alias).and_return(mock_alias)
    end

    context "always" do

      before(:each) do
        put :update, :physician_id => @mock_physician.id
      end

      it { assigns(:physician_alias).should eq(mock_alias) }
    end

    context "with valid parameters" do

      before(:each) do
        mock_alias.should_receive(:update_attributes).
          with("these" => :params).and_return(true)
        put :update, :physician_id => @mock_physician.id,
          :physician_alias => { :these => :params }
      end

      it { should redirect_to(physicians_path) }

      it { flash[:notice].should eq("Successfully updated alias") }
    end

    context "with invalid parameters" do

      before(:each) do
        mock_alias.should_receive(:update_attributes).
          with("these" => :params).and_return(false)
        put :update, :physician_id => @mock_physician.id,
          :physician_alias => { :these => :params }
      end

      it { should render_template(:edit) }
    end
  end
end
