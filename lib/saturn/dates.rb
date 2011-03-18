module Saturn

  module Dates

    # returns either the Monday in the week preceding/including :date,
    # or the Monday preceding/including the current date
    def monday_of_week_with(date)
      begin
        Date.parse(date).at_beginning_of_week
      rescue
        Date.today.at_beginning_of_week
      end
    end

    # returns every date in the week beginning on :date
    def week_dates_beginning_with(date)
      (date..date + 6).to_a
    end

    # returns the date of each Monday in the :year and :month
    def mondays_in(year, month)
      int_year = year.to_i
      first_of_month = Date.civil(int_year, month, 1)
      first_monday = first_of_month + (8 - first_of_month.wday) % 7
      days_in_month = Date.civil(int_year, month, -1).day
      (first_monday.day..days_in_month).to_a.each_slice(7).map do |days|
        Date.civil(int_year, month, days.first)
      end
    end
  end
end
