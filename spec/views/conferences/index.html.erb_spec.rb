require 'spec_helper'

describe "conferences/index.html.erb" do
  before(:each) do
    assign(:conferences, [
      stub_model(Conference,
        :title => "Title",
        :description => "MyText",
        :calcium_uid => "Calcium Uid",
        :categories => "MyText"
      ),
      stub_model(Conference,
        :title => "Title",
        :description => "MyText",
        :calcium_uid => "Calcium Uid",
        :categories => "MyText"
      )
    ])
  end

  it "renders a list of conferences" do
    render
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Calcium Uid".to_s, :count => 2
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
