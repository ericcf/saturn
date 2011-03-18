module Logical

  class YearlySectionSchedule < ::Logical::ValidatableModel

    attr_accessor :section
    attr_writer :year

    validates :year, :section, :presence => true

    def year
      @year.nil? ? nil : @year.to_i
    end

    def monthly_schedules
      @monthly_schedules ||= (1..12).map do |month|
        MonthlySectionSchedule.new(:year => year,
          :month => month,
          :section => section
        )
      end
    end
  end
end
