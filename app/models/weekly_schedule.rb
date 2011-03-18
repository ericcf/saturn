class WeeklySchedule < ActiveRecord::Base

  attr_accessible :section, :section_id, :date, :is_published,
    :assignments_attributes, :shift_week_notes_attributes

  has_many :shift_week_notes, :dependent => :destroy
  accepts_nested_attributes_for :shift_week_notes, :allow_destroy => true
  belongs_to :section

  validates_presence_of :section, :date
  validates_uniqueness_of :date, :scope => :section_id

  scope :include_dates, lambda { |dates|
    possible_schedule_dates = dates.sort.map do |date|
      (date - 6..date).select { |d| d.monday? }
    end.flatten.uniq
    where(:date => possible_schedule_dates)
  }
  scope :by_year, lambda { |year|
    where("weekly_schedules.date >= ? and weekly_schedules.date <= ?",
      Date.civil(year.to_i, 1, 1),
      Date.civil(year.to_i, 12, 31)
    )
  }
  scope :published, where(:is_published => true)
  default_scope :order => :date

  def shifts
    section.active_shifts(:as_of => date)
  end

  def assignments
    Assignment.where(:date => dates,
      :shift_id => shifts.map(&:id),
      :physician_id => section.member_ids
    )
  end

  def assignment_requests
    AssignmentRequest.include_dates(dates).
      where(:shift_id => shifts.map(&:id), :requester_id => section.member_ids)
  end

  def assignments_attributes=(attributes)
    assignment_ids = attributes.map { |attr| attr["id"] }
    assignments_to_update_or_destroy = assignments.where(:id => assignment_ids)
    assignments_to_update_or_destroy.each do |assignment|
      assignment_attributes = attributes.find { |a| a["id"] == assignment.id }
      if assignment_attributes.delete("_destroy") == true
        assignment.destroy
      else
        assignment.update_attributes(assignment_attributes)
      end
    end
    attributes.each do |assignment_attributes|
      if assignment_attributes["id"].nil?
        assignment_attributes.delete("_destroy")
        Assignment.create(assignment_attributes)
      end
    end
  end

  def read_only_assignments
    @read_only_assignments ||= assignments.select("date, duration, id, position, private_note, public_note, shift_id, physician_id, updated_at").includes(:shift)
  end

  def dates
    @dates ||= (date..date + 6.days).to_a
  end

  def holiday_titles_by_date
    @holidat_titles_by_date ||= Holiday.where(:date => dates).each_with_object({}) do |holiday, hsh|
      hsh[holiday.date] = holiday.title
    end
  end

  def rules_conflicts
    @rules_conflicts ||= ::Logical::RulesConflictSummary.new(
      :section => section,
      :weekly_schedule => self,
      :assignments => read_only_assignments,
      :ordered_physician_ids => section.members.order(:family_name).map(&:id)
    )
  end

  def to_json(options = {})
    options[:only_delta_attributes] ||= false
    static_attributes_json = nil
    static_attributes_json = options[:only_delta_attributes] ? nil : [
      date_json,
      section.members_by_group_json,
      dates_json
    ].join(",")
    [
      "{",
        "\"weekly_schedule\":",
          "{",
            [
            static_attributes_json,
            last_update_json,
            rules_conflicts.to_json,
            id ? "\"id\":#{id}" : nil,
            "\"is_published\":#{is_published}",
            "\"shift_weeks\":[#{shift_weeks_json}]",
            "\"error_messages\":#{errors.values.flatten.join(", ").to_json}",
            ].compact.join(","),
          "}",
      "}"
    ].join("")
  end

  def date_json
    [
    "\"date\":",
      "{",
        "\"year\":#{date.year},",
        "\"month\":#{date.month},",
        "\"day\":#{date.day}",
      "}"
    ].join("")
  end

  def dates_json
    "\"dates\":[#{dates.map do |date|
      [
      "{",
        "\"holiday_title\":#{holiday_titles_by_date[date].to_json},",
        "\"year\":#{date.year},",
        "\"month\":#{date.month},",
        "\"day\":#{date.day}",
      "}"
      ].join("")
    end.join(",")}]"
  end

  def assignments_by_shift_id_and_date
    return @mapped_assignments if @mapped_assignments
    @mapped_assignments =
        read_only_assignments.each_with_object({}) do |assignment, hsh|
      hsh[[assignment.shift_id, assignment.date]] ||= []
      hsh[[assignment.shift_id, assignment.date]] << assignment
    end
    assignment_requests.pending.each do |request|
      request.dates.each do |date|
        key = [request.shift_id, date]
        @mapped_assignments[key] ||= []
        @mapped_assignments[key] << AssignmentRequest.new(:start_date => date,
          :requester_id => request.requester_id,
          :shift_id => request.shift_id
        )
      end
    end
    @mapped_assignments
  end

  def shift_week_note(shift)
    @notes_by_shift_id ||= shift_week_notes.each_with_object({}) do |note, hsh|
      hsh[note.shift_id] = note
    end
    @notes_by_shift_id[shift.id] || ShiftWeekNote.new(:shift_id => shift.id)
  end

  def shift_weeks_json
    section.active_shifts(:as_of => date).select("shifts.id, shifts.title").map do |shift|
      [
      "{",
        "\"shift_id\":#{shift.id},",
        "\"shift_title\":#{shift.title.to_json},",
        shift_week_note(shift).to_json + ",",
        "\"shift_days\":[#{dates.map do |day|
          [
          "{",
            "\"date\":\"#{day}\",",
            "\"shift_id\":#{shift.id},",
            "\"assignments\":[#{(assignments_by_shift_id_and_date[[shift.id, day]] || []).map do |assignment|
              assignment.to_json
            end.join(",")}]",
          "}"
          ].join("")
        end.join(",")}]",
      "}"
      ].join("")
    end.join(",")
  end

  def last_update_json
    return nil unless last_update
    [
      "\"last_update\":",
        "{",
          "\"year\":#{last_update.year},",
          "\"month\":#{last_update.month},",
          "\"day\":#{last_update.day},",
          "\"hour\":#{last_update.hour},",
          "\"minute\":#{last_update.min}",
        "}"
    ].join("")
  end

  def last_update
    return @last_update if @last_update
    return nil unless updated_at
    last_assignment = assignments.order("updated_at DESC").limit(1).first
    @last_update = [
      updated_at,
      last_assignment ? last_assignment.updated_at : updated_at
    ].max
  end
end
