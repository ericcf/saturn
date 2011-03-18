require 'saturn/dates'

module Logical

  # A utility class that provides a weekly schedule for each week in the month.
  # It returns a dummy schedule in cases where the schedule is not published.
  class MonthlySectionSchedule < ::Logical::ValidatableModel

    include Saturn::Dates

    attr_accessor :section
    attr_writer :year, :month

    validates :year, :month, :section, :presence => true

    def month_name
      Date::MONTHNAMES[month]
    end

    def year
      @year.nil? ? nil : @year.to_i
    end

    def month
      @month.nil? ? nil : @month.to_i
    end

    def weekly_schedules
      return @weekly_schedules if @weekly_schedules
      @weekly_schedules = mondays_in_month.map do |date|
        published_schedules_by_date[date] ||
          WeeklySchedule.new(:date => date, :section => section)
      end
    end

    private

    def mondays_in_month
      @mondays_in_month ||= mondays_in(year, month)
    end

    def published_schedules_by_date
      @published_schedules_by_date ||= section.weekly_schedules.published.
        include_dates(mondays_in_month).each_with_object({}) do |schedule, hash|
          hash[schedule.date] = schedule
        end
    end
  end
end
