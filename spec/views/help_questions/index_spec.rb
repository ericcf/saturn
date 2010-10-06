require 'spec_helper'

describe "help_questions/index" do

  before(:each) do
    @questions = assign(:help_questions, [
      mock_model(HelpQuestion, :title => "Lorem ipsum...?",
        :answer => "dolor amet.")
    ])
    view.should_receive(:nav_item).with("Add Question", new_help_question_path,
      {}, :create, HelpQuestion)
    render
  end

  it "renders a list of anchor links" do
    rendered.should have_selector("ol li a",
      :href => help_questions_path(:anchor => "faq-#{@questions.first.id}"),
      :content => @questions.first.title)
  end

  it "renders a list of anchored answers" do
    rendered.should have_selector("ol li") do |item|
      item.should have_selector("dl") do |list|
        list.should have_selector("dt") do |term|
          term.should have_selector("a", :name => "faq-#{@questions.first.id}")
          term.should contain(@questions.first.title)
        end
        list.should have_selector("dd", :content => @questions.first.answer)
      end
    end
  end
end
