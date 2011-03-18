module Logical

  class PhysicianSchedule < ::Logical::ValidatableModel

    attr_accessor :start_date, :number_of_days, :physician

    validates :start_date, :number_of_days, :physician, :presence => true

    def dates
      @dates ||= (@start_date..@start_date + @number_of_days - 1).to_a
    end

    def assignments_for_section_and_date(section, date)
      section_assignments = published_assignments_by_section[section] || []
      section_assignments.group_by(&:date)[date]
    end

    def published_assignments_by_section
      @published_assignments_by_section ||= physician.sections.each_with_object({}) do |section, hsh|
        hsh[section] = section.published_assignments_by_dates(dates).
          where(:physician_id => physician.id)
      end
    end
  end
end
