$:.unshift File.join(File.dirname(__FILE__), "..")
require 'page'

module ReportPages

  class ShiftTotals < Page

    def visit
      @page.visit "/sections/#{@options[:section_id]}/reports/shift_totals"
    end

    def start_date=(date)
      @page.fill_in "start_date", :with => date_to_db(date)
    end

    def end_date=(date)
      @page.fill_in "end_date", :with => date_to_db(date)
    end

    def get_report
      @page.click_on "Get Report"
    end
  end
end
