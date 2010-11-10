require 'spec_helper'

describe "conferences/index" do
  before(:each) do
    assign(:date, Date.today)
    assign(:conferences, [
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
    ])
  end

  it "renders a list of conferences" do
    render
    assert_select "tr>td", :text => "Title", :count => 2
    assert_select "tr>td", :text => "Description", :count => 2
    assert_select "tr>td", :text => "Categories", :count => 2
  end
end
