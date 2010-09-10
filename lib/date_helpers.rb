module DateHelpers

  def monday_of_week_with(date)
    begin
      Date.parse(date).at_beginning_of_week
    rescue
      Date.today.at_beginning_of_week
    end
  end

  def week_dates_beginning_with(date)
    (date..date+6).to_a
  end
end
