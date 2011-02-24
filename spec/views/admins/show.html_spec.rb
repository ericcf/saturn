require 'spec_helper'

describe "admins/show.html.haml" do

  let(:mock_section) { stub_model(Section) }
  let(:mock_users) { [stub_model(Deadbolt::User)] }

  before(:each) do
    assign(:section, mock_section)
    assign(:users, mock_users)
    should_render_partial("schedules/section_menu")
    render
  end

  subject { rendered }

  it { should have_selector("form",
    :action => section_admins_path(mock_section)) }

  it { should have_selector("form input", :type => "checkbox",
    :name => "admin_ids[#{mock_users.first.id}]") }
end
