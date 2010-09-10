require 'spec_helper'

describe ShiftTagsController do

  describe "routing" do

    it "recognizes and generates #search" do
      assert_recognizes({ :controller => "shift_tags", :action => "search", :section_id => "1", :format => "json" }, "/sections/1/shift_tags/search.json")
    end
  end
end
