require 'spec_helper'

describe "conferences/show.html.erb" do
  before(:each) do
    @conference = assign(:conference, stub_model(Conference,
      :title => "Title",
      :description => "MyText",
      :calcium_uid => "Calcium Uid",
      :categories => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    rendered.should match(/Title/)
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    rendered.should match(/Calcium Uid/)
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    rendered.should match(/MyText/)
  end
end
