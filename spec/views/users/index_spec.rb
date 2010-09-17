require 'spec_helper'

describe "users/index" do

  before(:each) do
    @users = assign(:users, [mock_model(User).as_null_object])
    render
  end

  it "renders a form for updating users" do
    rendered.should have_selector("form", :action => roles_users_path)
  end

  it "renders a check box for the admin attribute on a user" do
    rendered.should have_selector("form input",
      :type => "checkbox",
      :name => "users[#{@users.first.id}][admin]")
  end
end
