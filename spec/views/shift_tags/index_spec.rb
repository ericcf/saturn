require 'spec_helper'

describe "shift_tags/index" do

  before(:each) do
    @mock_section = assign(:section, stub_model(Section))
    @mock_shift = mock_model(Shift, :title => "AM Call")
    @mock_shift_tag = stub_model(ShiftTag, :title => "Call",
      :shifts => [@mock_shift], :display_color => "abcdef")
    @mock_orphan_tag =  stub_model(ShiftTag, :title => "Baz", :shifts => [])
    assign(:shift_tags, [@mock_shift_tag, @mock_orphan_tag])
    should_render_partial("schedules/section_menu")
    render
  end

  it "renders a link to add a new tag" do
    rendered.should have_selector("a",
      :href => new_section_shift_tag_path(@mock_section),
      :content => "Add Category"
    )
  end

  it "renders a form for updating tags" do
    rendered.should have_selector("form",
      :action => section_path(@mock_section),
      :method => "post"
    ) do |form|
      form.should have_selector("input", :type => "submit")
    end
  end

  it "renders a hidden field with the redirect_path" do
    rendered.should have_selector("form input",
      :type => "hidden",
      :name => "redirect_path",
      :value => section_shift_tags_path(@mock_section)
    )
  end

  it "renders the title field" do
    rendered.should have_selector("form") do |form|
      form.should have_selector("input",
        :type => "text",
        :name => "section[shift_tags_attributes][0][title]",
        :value => @mock_shift_tag.title
      )
    end
  end

  it "renders the shifts associated with each tag" do
    rendered.should have_selector("td", :content => @mock_shift.title)
  end

  it "renders the display_color select menu" do
    rendered.should have_selector("form select",
      :name => "section[shift_tags_attributes][0][display_color]")
  end

  it "renders a checkbox to remove tags from associated shifts" do
    rendered.should have_selector("form input",
      :type => "checkbox",
      :name => "section[shift_tags_attributes][0][clear_assignments]"
    )
  end

  it "renders a checkbox to delete tags with no associated shifts" do
    rendered.should have_selector("form input",
      :type => "checkbox",
      :name => "section[shift_tags_attributes][1][_destroy]"
    )
  end
end
