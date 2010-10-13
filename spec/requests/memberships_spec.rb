require 'spec_helper'

include AuthenticationHelpers

describe "memberships" do

  describe "get new" do

    it "is successful" do
      sign_in_user :admin => true
      section = Factory(:section)
      get new_section_membership_path(section)
      response.should be_successful
    end
  end
end
