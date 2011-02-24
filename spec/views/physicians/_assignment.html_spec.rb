require 'spec_helper'

describe "physicians/_assignment.html" do

  let(:mock_assignment) do
    stub_model(Assignment, :public_note => "foobar", :shift_title => "barfoo")
  end

  before(:each) do
    render :partial => "physicians/assignment.html",
      :locals => { :assignment => mock_assignment }
  end

  subject { rendered }

  it { should contain(mock_assignment.shift_title) }

  it do
    should have_selector("span.note") do |note_element|
      note_element.should have_selector("img[alt=#{mock_assignment.public_note}]")
      note_element.should have_selector("span.note-text", :content => mock_assignment.public_note)
    end
  end
end
