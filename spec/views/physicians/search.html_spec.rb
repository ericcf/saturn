require 'spec_helper'

describe "physicians/search.html" do

  context "no search results" do

    before(:each) do
      render
    end

    subject { rendered }

    it "renders a search box" do
      should have_selector("form", :action => search_physicians_path,
        :method => "get") do |form|
        form.should have_selector("input", :name => "query")
      end
    end

    it "renders a submit button" do
      should have_selector("input.button",
        :value => "Search Physicians")
    end
  end

  context "search results present" do

    before(:each) do
      physicians = [mock_model(Physician)]
      assign(:physicians, physicians)
      dates = assign(:dates, [Date.today])
      mock_assignments = assign(:assignments, [
        stub_model(Assignment),
        stub_model(Assignment)
      ])
      assign(:query, "bro")
      view.should_receive(:physicians_weekly_schedules).
        with(physicians, dates, mock_assignments)
    end

    it "renders the search query" do
      render
      rendered.should have_selector("h3", :content => "1 Result for 'bro'")
    end

    it "renders the weekly_schedule partial" do
      render
      should render_template(:partial => "schedules/_date_header")
    end
  end
end
