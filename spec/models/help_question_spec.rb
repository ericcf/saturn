require 'spec_helper'

describe HelpQuestion do

  before(:each) do
    @valid_attributes = {
      :title => "why?",
      :answer => "because"
    }
    @question = HelpQuestion.create(@valid_attributes)
    @question.should be_valid
  end

  # validations

  it { should validate_presence_of(:title) }

end
