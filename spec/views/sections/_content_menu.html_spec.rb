require 'spec_helper'

describe "sections/_content_menu.html" do

  let(:today) { Date.today }
  let(:mock_section) { stub_model(Section, :title => "Foo") }

  before(:each) do
    view.stub!(:cannot?)
    render "sections/content_menu", :section => mock_section, :date => today
  end

  subject { rendered }

  it { should have_selector("h2", :content => mock_section.title) }
end
