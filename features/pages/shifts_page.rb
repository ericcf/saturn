class ShiftsPage < Page

  def visit
    @page.visit "/sections/#{@options[:section_id]}/shifts"
  end

  def retire_shift(index)
    @page.check "section[section_shifts_attributes][0][retire]"
  end

  def update
    @page.click_on "Update Section"
  end

  def retired_shifts
    @page.find("#retired_shifts").all("td:first").map &:text
  end
end
