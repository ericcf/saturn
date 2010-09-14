require 'spec_helper'

describe PeopleController do

  def mock_person(stubs={})
    @mock_person ||= mock_model(Person, stubs).as_null_object
  end

  describe "GET 'index'" do

    before(:each) do
      Person.should_receive(:all).and_return([mock_person])
      get :index
    end

    it { assigns(:people).should eq([mock_person]) }
  end

  describe "GET 'show'" do

    context "the requested person is found" do

      before(:each) do
        Person.should_receive(:find).with(mock_person.id).
          and_return(mock_person)
        get :show, :id => mock_person.id
      end

      it { assigns(:person).should eq(mock_person) }
    end

    context "the requested person is not found" do

      before(:each) do
        Person.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        get :show, :id => 1
      end

      it { flash[:error].should == "Error: requested person not found" }

      it { should redirect_to(people_path) }
    end
  end

  describe "GET 'edit'" do

    before(:each) do
      controller.should_receive(:authenticate_user!)
    end

    context "the requested person is found" do

      before(:each) do
        Person.should_receive(:find).with(mock_person.id).
          and_return(mock_person)
        controller.should_receive(:authorize!).with(:update, mock_person)
      end

      context "always" do

        before(:each) { get :edit, :id => mock_person.id }

        it { assigns(:person).should eq(mock_person) }

        it { should render_template(:edit) }
      end

      context "and has no associated names_alias" do

        it "builds one" do
          mock_person.should_receive(:build_names_alias)
          mock_person.stub!(:names_alias)
          get :edit, :id => mock_person.id
        end
      end

      context "and has an associated names_alias" do

        it "does not build one" do
          mock_person.should_not_receive(:build_names_alias)
          mock_person.stub!(:names_alias).and_return(mock_model(PersonAlias))
          get :edit, :id => mock_person.id
        end
      end
    end

    context "the requested person is not found" do

      before(:each) do
        Person.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        get :edit, :id => 1
      end

      it { flash[:error].should == "Error: requested person not found" }

      it { should redirect_to(people_path) }
    end
  end

  describe "PUT 'update'" do

    before(:each) do
      controller.should_receive(:authenticate_user!)
    end

    context "the requested person is found" do

      context "always" do

        before(:each) do
          mock_person.should_receive(:update_attributes).
            with("these" => :params)
          Person.should_receive(:find).with(mock_person.id).
            and_return(mock_person)
          controller.stub!(:authorize!)
          put :update, :id => mock_person.id, :person => { :these => :params }
        end

        it { assigns(:person).should eq(mock_person) }
      end

      context "with valid parameters" do

        before(:each) do
          Person.stub!(:find).
            and_return(mock_person(:update_attributes => true))
          controller.should_receive(:authorize!).with(:update, mock_person)
          put :update, :id => mock_person.id
        end

        it { should redirect_to(person_path(mock_person)) }
      end

      context "with invalid parameters" do

        before(:each) do
          Person.stub!(:find).
            and_return(mock_person(:update_attributes => false))
          controller.should_receive(:authorize!).with(:update, mock_person)
          put :update, :id => mock_person.id
        end

        it { should render_template(:edit) }
      end
    end

    context "the requested person is not found" do

      before(:each) do
        Person.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        put :update, :id => 1
      end

      it { flash[:error].should == "Error: requested person not found" }

      it { should redirect_to(people_path) }
    end
  end

  describe "GET schedule" do

    context "the requested person is found" do

      before(:each) do
        Person.should_receive(:find).with(mock_person.id).
          and_return(mock_person)
      end

      context "any format" do

        before(:each) do
          get :schedule, :id => mock_person.id
        end

        it { assigns(:person).should == mock_person }

        it { assigns(:dates).should include(Date.today) }
      end

      context "the format is ics" do

        before(:each) do
          get :schedule, :id => mock_person.id, :format => "ics"
        end

        it { response.content_type.should == "text/calendar" }
      end
    end

    context "the requested person is not found" do

      before(:each) do
        Person.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        get :schedule, :id => 1
      end

      it { flash[:error].should == "Error: requested person not found" }

      it { should redirect_to(people_path) }
    end
  end
end
