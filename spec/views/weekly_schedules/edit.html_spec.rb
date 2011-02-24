require 'spec_helper'

describe "weekly_schedules/edit.html" do

  let(:mock_section) { stub_model(Section, :title => "Foo") }

  it do
    assign(:section, mock_section)
    view.stub!(:cannot?)
    render
    rendered.should have_selector("div#schedule")
  end
end
