require 'spec_helper'

describe "admin/index" do

  before(:each) do
    should_render_partial("deadbolt/shared_partials/admin_menu")
    render
  end

  it "renders a link to site statistics" do
    rendered.should have_selector("ul li a", :href => site_statistics_path,
      :content => "Site Statistics")
  end
end
