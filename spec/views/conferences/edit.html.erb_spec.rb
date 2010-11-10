require 'spec_helper'

describe "conferences/edit.html.erb" do
  before(:each) do
    @conference = assign(:conference, stub_model(Conference,
      :new_record? => false,
      :title => "MyString",
      :description => "MyText",
      :calcium_uid => "MyString",
      :categories => "MyText"
    ))
  end

  it "renders the edit conference form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => conference_path(@conference), :method => "post" do
      assert_select "input#conference_title", :name => "conference[title]"
      assert_select "textarea#conference_description", :name => "conference[description]"
      assert_select "input#conference_calcium_uid", :name => "conference[calcium_uid]"
      assert_select "textarea#conference_categories", :name => "conference[categories]"
    end
  end
end
