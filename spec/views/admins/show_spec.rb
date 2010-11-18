require 'spec_helper'

describe "admins/show" do

  before(:each) do
    @mock_section = assign(:section, stub_model(Section))
    @mock_users = assign(:users, [stub_model(Deadbolt::User)])
    should_render_partial("schedules/section_menu")
    render
  end

  subject { rendered }

  it { should have_selector("form",
    :action => section_admins_path(@mock_section)) }

  it { should have_selector("form input", :type => "checkbox",
    :name => "admin_ids[#{@mock_users.first.id}]") }
end
