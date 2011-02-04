class WeeklySchedule < ActiveRecord::Base

  has_many :assignments, :dependent => :destroy
  accepts_nested_attributes_for :assignments, :allow_destroy => true
  belongs_to :section

  validates_presence_of :section, :date
  validates_uniqueness_of :date, :scope => :section_id

  scope :include_date, lambda { |date|
    where("weekly_schedules.date <= ? and weekly_schedules.date >= ?", date, date - 6)
  }

  def read_only_assignments
    @read_only_assignments ||= assignments.select("date, duration, id, position, private_note, public_note, shift_id, physician_id, updated_at")
  end

  def shift_weeks_json
    assignments_by_shift_id_and_date = read_only_assignments.each_with_object({}) do |assignment, hsh|
      hsh[[assignment.shift_id, assignment.date]] ||= []
      hsh[[assignment.shift_id, assignment.date]] << assignment
    end
    section.shifts.select("id, title").active_as_of(date).map do |shift|
      [
      "{",
        "\"shift_title\":\"#{shift.title}\",",
        "\"shift_days\":[#{(date..date+6.days).map do |day|
          [
          "{",
            "\"date\":\"#{day}\",",
            "\"shift_id\":#{shift.id},",
            "\"assignments\":[#{(assignments_by_shift_id_and_date[[shift.id, day]] || []).map do |assignment|
              [
              "{",
                "\"assignment\":{",
                  "\"date\":\"#{assignment.date}\",",
                  assignment.duration ? "\"duration\":#{assignment.duration}," : nil,
                  "\"id\":#{assignment.id},",
                  "\"position\":#{assignment.position},",
                  assignment.private_note.present? ? "\"private_note\":\"#{assignment.private_note}\"," : nil,
                  assignment.public_note.present? ? "\"public_note\":\"#{assignment.public_note}\"," : nil,
                  "\"shift_id\":#{shift.id},",
                  "\"physician_id\":#{assignment.physician_id}",
                "}",
              "}"
              ].join("")
            end.join(",")}]",
          "}"
          ].join("")
        end.join(",")}]",
      "}"
      ].join("")
    end.join(",")
  end
end
