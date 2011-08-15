module Logical

  # Collects all CallShift assignments for the specified dates
  class CallSchedulePresenter < ::Logical::ValidatableModel

    attr_accessor :dates

    validates :dates, :presence => true

    def summaries_by_section_id_shift_id_and_date(section_id, shift_id, date)
      assignments = mapped_assignments[[section_id, shift_id, date]] || []
      assignments.map do |assignment|
        {
          :text => physicians_by_id[assignment.physician_id].short_name,
          :note => assignment.public_note,
          :duration => assignment.duration
        }
      end
    end

    def shifts_by_section
      CallShift.includes(:sections).group_by { |shift| shift.sections.first }
    end

    private

    def mapped_assignments
      return @mapped_assignments if @mapped_assignments
      @mapped_assignments = {}
      Section.all.each do |section|
        section.published_assignments_by_dates(dates).each do |assignment|
          key = [section.id, assignment.shift_id, assignment.date]
          @mapped_assignments[key] ||= []
          @mapped_assignments[key] << assignment
        end
      end
      @mapped_assignments
    end

    def physicians_by_id
      @physicians_by_id ||= 
        Physician.all.each_with_object({}) do |record, hash|
          hash[record.id] = record
        end
    end
  end
end
