require 'spec_helper'

describe "people/search" do

  context "no search results" do

    before(:each) do
      render
    end

    it "renders a search box" do
      rendered.should have_selector("form", :action => search_people_path,
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
      @mock_person = stub_model(Person)
      @mock_person.stub!(:full_name).with(:family_first).
        and_return("John, Brother")
      assign(:people, [@mock_person])
      assign(:query, "bro")
      render
    end

    it "renders the search query" do
      rendered.should have_selector("h3", :content => "Results for 'bro'")
    end

    it "renders links to each person" do
      rendered.should have_selector("dl dt a",
        :content => @mock_person.full_name(:family_first),
        :href => schedule_person_path(@mock_person))
    end
  end
end
