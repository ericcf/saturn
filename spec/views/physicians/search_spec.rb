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
      physicians = mock("physicians", :total_entries => 1, :total_pages => 1)
      assign(:physicians, physicians)
      dates = assign(:dates, [Date.today])
      @mock_assignments = assign(:assignments, [
        stub_model(Assignment),
        stub_model(Assignment)
      ])
      assign(:query, "bro")
      view.should_receive(:physicians_weekly_schedules).
        with(physicians, dates, @mock_assignments)
    end

    it "renders the search query" do
      render
      rendered.should have_selector("h3", :content => "1 Result for 'bro'")
    end

    it "renders the weekly_schedule partial" do
      should_render_partial("weekly_schedule").once
      render
    end
  end
end
