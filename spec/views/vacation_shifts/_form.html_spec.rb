require 'spec_helper'

describe "vacation_shifts/_form.html" do

  let(:mock_section) { stub_model(Section) }
  let(:mock_vacation_shift) { stub_model(VacationShift) }

  before(:each) do
    render "vacation_shifts/form", :section => mock_section,
      :vacation_shift => mock_vacation_shift
  end

  subject { rendered }

  it "renders a form for creating a vacation shift" do
    should have_selector("form",
      :action => section_vacation_shift_path(mock_section, mock_vacation_shift),
      :method => "post"
    ) do |form|
      form.should have_selector("input", :type => "submit")
    end
  end

  it "renders a field for the title" do
    should have_selector("form input",
      :type => "text",
      :name => "vacation_shift[title]"
    )
  end

  it "renders a fieldset to select shared sections when not a new record" do
    should have_selector("form input",
      :name => "vacation_shift[section_ids][]"
    )
  end
end
