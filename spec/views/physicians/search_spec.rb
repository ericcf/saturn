require 'spec_helper'

describe "physicians/search" do

  context "no search results" do

    before(:each) do
      render
    end

    it "renders a search box" do
      rendered.should have_selector("form", :action => search_physicians_path,
        :method => "get") do |form|
        form.should have_selector("input", :name => "query")
      end
    end

    it "renders a submit button" do
      rendered.should have_selector("input.submit",
        :value => "Search Physicians")
    end
  end

  context "search results present" do

    before(:each) do
      @mock_physician = stub_model(Physician)
      @mock_physician.stub!(:full_name).with(:family_first).
        and_return("John, Brother")
      physicians = [@mock_physician]
      physicians.stub!(:total_entries).and_return(1)
      physicians.stub!(:total_pages).and_return(1)
      assign(:physicians, physicians)
      assign(:shifts_by_physician, {})
      assign(:query, "bro")
      render
    end

    it "renders the search query" do
      rendered.should have_selector("h3", :content => "1 Result for 'bro'")
    end

    it "renders links to each physician" do
      rendered.should have_selector("table tr td a",
        :content => @mock_physician.full_name(:family_first),
        :href => schedule_physician_path(@mock_physician))
    end
  end
end
