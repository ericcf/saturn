require 'spec_helper'

describe "help_questions/edit" do

  before(:each) do
    assign(:help_question, stub_model(HelpQuestion))
    should_render_partial("form")
    render
  end
end
