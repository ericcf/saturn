require 'spec_helper'

describe "shift_tags/index.html" do

  let(:mock_section) { stub_model(Section) }
  let(:mock_shift) { stub_model(Shift, :title => "AM Call") }
  let(:mock_shift_tag) do
    mock_model(ShiftTag,
      :title => "Call",
      :shifts => [mock_shift]
    ).as_null_object
  end
  let(:mock_orphan_tag) { stub_model(ShiftTag, :title => "Baz", :shifts => []) }

  before(:each) do
    assign(:section, mock_section)
    assign(:shift_tags, [mock_shift_tag, mock_orphan_tag])
    should_render_partial("schedules/section_menu.html")
    render
  end

  subject { rendered }

  it "renders a link to add a new tag" do
    should have_selector("a",
      :href => new_section_shift_tag_path(mock_section),
      :content => "Add Category"
    )
  end

  it "renders a form for updating tags" do
    should have_selector("form",
      :action => section_path(mock_section),
      :method => "post"
    ) do |form|
      form.should have_selector("input", :type => "submit")
    end
  end

  it "renders a hidden field with the redirect_path" do
    should have_selector("form input",
      :type => "hidden",
      :name => "redirect_path",
      :value => section_shift_tags_path(mock_section)
    )
  end

  it "renders the title field" do
    should have_selector("form") do |form|
      form.should have_selector("input",
        :type => "text",
        :name => "section[shift_tags_attributes][0][title]",
        :value => mock_shift_tag.title
      )
    end
  end

  it "renders the shifts associated with each tag" do
    should have_selector("td", :content => mock_shift.title)
  end

  it "renders a checkbox to remove tags from associated shifts" do
    should have_selector("form input",
      :type => "checkbox",
      :name => "section[shift_tags_attributes][0][clear_assignments]"
    )
  end

  it "renders a checkbox to delete tags with no associated shifts" do
    should have_selector("form input",
      :type => "checkbox",
      :name => "section[shift_tags_attributes][1][_destroy]"
    )
  end
end
