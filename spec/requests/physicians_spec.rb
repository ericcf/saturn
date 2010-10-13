require 'spec_helper'

describe "physicians" do

  include AuthenticationHelpers

  def physician_record
    @physician_record ||= Factory(:physician)
  end

  describe "index" do

    context "with no physicians present" do

      it "renders successfully" do
        get physicians_path
        response.should be_success
      end
    end

    context "with physicians present" do

      context "who are associated with sections" do

        it "renders a link to each physician's schedule" do
          SectionMembership.delete_all; Physician.delete_all; Section.delete_all
          physician = Factory(:physician)
          section = Factory(:section)
          SectionMembership.create(:physician => physician, :section => section)
          get physicians_path
          response.should have_selector("a",
            :href => schedule_physician_path(physician),
            :content => physician.given_name
          )
        end
      end
    end
  end

  describe "edit alias" do

    before(:each) do
      sign_in_user :admin => true
    end

    it "renders a form for updating the alias" do
      names_alias = Factory(:physician_alias, :physician => physician_record)
      get edit_physician_physician_alias_path(physician_record, names_alias)
      response.should have_selector("form",
        :action => physician_physician_alias_path(physician_record)
      )
    end
  end

  describe "update alias" do

    before(:each) do
      sign_in_user :admin => true
    end

    context "with valid parameters" do

      it "updates the requested physician's alias" do
        names_alias = Factory(:physician_alias, :physician => physician_record)
        put physician_physician_alias_path(physician_record),
          :physician_alias => {
            :initials => "MM",
            :short_name => "M. Mouse"
          }
        physician = Physician.order("contacts.id").last
        physician.initials.should == "MM"
        physician.short_name.should == "M. Mouse"
      end
    end

    context "with invalid parameters" do

      it "does not update the requested physician's alias" do
        names_alias = Factory(:physician_alias, :physician => physician_record)
        put physician_physician_alias_path(physician_record),
          :physician_alias => {
            :initials => nil
          }
        Physician.last.initials.should_not be_nil
      end
    end
  end
end
