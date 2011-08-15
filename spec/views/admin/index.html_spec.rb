require 'spec_helper'

describe "admin/index.html.haml" do

  before(:each) do
    view.stub! :can?
    render
    should render_template(:partial => "deadbolt/shared_partials/_admin_menu")
  end

  subject { rendered }

  it "renders a link to site statistics" do
    should have_selector("ul li a", :href => site_statistics_path,
      :content => "Site Statistics")
  end
end
