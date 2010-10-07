require 'spec_helper'

describe "people/_form" do

  def mock_person(stubs={})
    @mock_person ||= stub_model(Person, stubs).as_null_object
  end

  def mock_person_alias(stubs={})
    @mock_person_alias ||= stub_model(PersonAlias, stubs).as_null_object
  end

  it "renders a form for updating the person" do
    mock_person_alias(:short_name => nil, :initials => nil)
    assign(:person, mock_person(:names_alias => mock_person_alias))
    render
    rendered.should have_selector("form",
      :action => person_path(mock_person),
      :method => "post"
    ) do |form|
      form.should have_selector("input", :type => "submit")
    end
  end

  it "renders a label for initials" do
    mock_person_alias(:short_name => nil, :initials => "AB")
    assign(:person, mock_person(:names_alias => mock_person_alias))
    render
    rendered.should have_selector("label", :content => "Initials")
  end
end
