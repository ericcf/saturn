require 'spec_helper'

describe "conferences/index.html.haml" do

  let(:date) { Date.today }
  let(:mock_conferences) do
    [
      stub_model(Conference,
        :title => "Title",
        :description => "Description",
        :external_uid => "Calcium Uid",
        :categories => "Categories",
        :starts_at => DateTime.now,
        :ends_at => DateTime.now
      ),
      stub_model(Conference,
        :title => "Title",
        :description => "Description",
        :external_uid => "Calcium Uid",
        :categories => "Categories",
        :starts_at => DateTime.now,
        :ends_at => DateTime.now
      )
    ]
  end

  before(:each) do
    assign(:date, date)
    assign(:conferences, mock_conferences)
    render
  end

  subject { rendered }

  it "renders a list of conferences" do
    assert_select "tr>td", :text => "Title", :count => 2
    assert_select "tr>td", :text => "Description", :count => 2
    assert_select "tr>td", :text => "Categories", :count => 2
  end
end
