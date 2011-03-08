require 'spec_helper'

describe "shifts/_form.html" do

  let(:mock_section) { stub_model(Section) }
  let(:mock_shift) { stub_model(Shift) }

  before(:each) do
    render "shifts/form", :section => mock_section, :shift => mock_shift
  end

  subject { rendered }

  it "renders a form for creating a shift" do
    should have_selector("form",
      :action => section_shift_path(mock_section, mock_shift),
      :method => "post"
    ) do |form|
      form.should have_selector("input", :type => "submit")
    end
  end

  it "renders a field for the title" do
    should have_selector("form input",
      :type => "text",
      :name => "shift[title]"
    )
  end

  it "renders a fieldset to select shared sections when not a new record" do
    should have_selector("form input",
      :name => "shift[section_ids][]"
    )
  end
end
