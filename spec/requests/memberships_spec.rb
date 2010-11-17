require 'spec_helper'

include AuthenticationHelpers

describe "memberships" do

  describe "get manage_new" do

    it "is successful" do
      sign_in_user :admin => true
      section = Factory(:section)
      get manage_new_section_memberships_path(section)
      response.should be_successful
    end
  end
end
