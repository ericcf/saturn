require 'spec_helper'

describe "help_questions/_form" do

  before(:each) do
    assign(:help_question, stub_model(HelpQuestion))
    render
  end

  it "renders a field for the title" do
    rendered.should have_selector("form textarea",
      :name => "help_question[title]")
  end

  it "renders a field for the answer" do
    rendered.should have_selector("form textarea",
      :name => "help_question[answer]")
  end
end
