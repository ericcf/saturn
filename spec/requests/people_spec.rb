require 'spec_helper'

include  Webrat::Matchers

describe "people" do

  def person_record(attributes={})
    @person_record ||= Factory(:person, attributes)
  end

  describe "index" do

    context "with no people present" do

      it "renders successfully" do
        get people_path
        response.should be_success
      end
    end

    context "with people present" do

      context "who are associated with sections" do

        #it "renders a link to each person" do
        #  Section.delete_all
        #  person = Factory(:person)
        #  section = Factory(:section)
        #  person.sections << section
        #  get people_path
        #  response.should have_selector("a",
        #    :href => person_path(person),
        #    :content => person.given_name
        #  )
        #end
      end
    end
  end

  describe "show" do

    context "a valid person" do

      it "renders the given name" do
        get person_path(person_record)
        response.should have_selector("h2",
          :content => person_record.given_name
        )
      end
    end

    context "a nonexistant person" do

      before(:each) do
        get person_path(:id => 0)
      end

      it "renders an error message" do
        flash[:error].should match(/Error:/)
      end

      it "redirects to the index" do
        response.should redirect_to(people_path)
      end
    end
  end

  describe "edit" do

    context "an existing person" do

      it "renders a form for updating the person" do
        get edit_person_path(person_record)
        response.should have_selector("form",
          :action => person_path(person_record)
        )
      end
    end

    context "a nonexistant person" do

      before(:each) do
        get edit_person_path(:id => 0)
      end

      it "renders an error message" do
        flash[:error].should match(/Error:/)
      end

      it "redirects to the index" do
        response.should redirect_to(people_path)
      end
    end
  end

  describe "update" do

    context "an existing person" do

      context "with valid parameters" do

        it "updates the requested Person" do
          put person_path(person_record), :person => {
            :names_alias_attributes => {
              :initials => "MM",
              :short_name => "M. Mouse"
            }
          }
          person = Person.find(:last, :order => :id)
          person.initials.should == "MM"
          person.short_name.should == "M. Mouse"
        end
      end

      context "with invalid parameters" do

        it "does not update the requested Person" do
          put person_path(person_record), :person => {
            :given_name => nil
          }
          Person.last.given_name.should_not be_nil
        end
      end
    end

    context "a nonexistant person" do

      before(:each) do
        put person_path(:id => 0)
      end

      it "renders an error message" do
        flash[:error].should match(/Error:/)
      end

      it "redirects to the index" do
        response.should redirect_to(people_path)
      end
    end
  end
end
