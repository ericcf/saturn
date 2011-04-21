module Logical

  class SectionCallSchedule < ::Logical::ValidatableModel

    attr_accessor :section_id, :date

    validates :section_id, :date, :presence => true

    def section
      @section ||= Section.find(section_id)
    end

    def assignments
      @assignments ||= section.published_assignments_by_dates([date]).
        where(:date => date, :shift_id => CallShift.all.map(&:id))
    end

    def as_json(options = nil)
      {
        :section_title => section.title,
        :assignments => assignments_to_a
      }
    end

    private

    def assignments_to_a
      assignments.map do |assignment|
        {
          :physician_id => assignment.physician_id,
          :shift_title => assignment.shift_title
        }
      end
    end
  end
end
