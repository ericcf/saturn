require 'spec_helper'

describe "people/_form" do

  def mock_person(stubs={})
    @mock_person ||= mock_model(Person, stubs).as_null_object
  end

  def mock_person_alias(stubs={})
    @mock_person_alias ||= mock_model(PersonAlias, stubs).as_null_object
  end

  it "renders a form for updating the person" do
    assign(:person, mock_person)
    render
    rendered.should have_selector("form",
      :action => person_path(mock_person),
      :method => "post"
    ) do |form|
      form.should have_selector("input", :type => "submit")
    end
  end

  it "renders a label for initials" do
    assign(:person, mock_person(:initials => "AB"))
    render
    rendered.should have_selector("label", :content => "Initials")
  end
end
