class Assignment < ActiveRecord::Base

  belongs_to :weekly_schedule
  belongs_to :shift
  belongs_to :physician

  # NOT validating presence of shift and physician (for now) because it vastly
  # slows down mass assignments
  validates :shift_id, :physician_id, :date, :presence => true
  validates_numericality_of :position,
    :greater_than_or_equal_to => 1
  validates_uniqueness_of :physician_id,
    :scope => [:weekly_schedule_id, :shift_id, :date],
    :message => "Duplicate assignments not allowed"

  before_validation :filter_attributes

  scope :by_schedules_and_shifts, lambda { |schedules, shifts|
    where(:weekly_schedule_id => schedules.map(&:id),
          :shift_id => shifts.map(&:id))
  }
  scope :date_in_range, lambda { |start_date, end_date|
    where("assignments.date >= ? and assignments.date <= ?", start_date, end_date)
  }
  scope :published, lambda {
    joins(:weekly_schedule).where("weekly_schedules.is_published = 1")
  }
  default_scope order("assignments.position")

  def physician_name
    physician.present? ? physician.short_name : "Na"
  end

  def public_note_details
    public_note.blank? ? nil : {
      :shift => shift.title,
      :day => date.strftime("%a"),
      :initials => physician.initials,
      :text => public_note
    }
  end

  def fixed_duration
    duration || shift.duration
  end

  def to_ics_event(event)
    event.dtstart date
    event.dtend date
    event.summary shift.title
  end

  def to_json
    [
    "{",
      "\"assignment\":{",
        "\"date\":\"#{date}\",",
        "\"duration\":#{duration || "null"},",
        "\"id\":#{id},",
        "\"position\":#{position},",
        "\"private_note\":#{"\"#{private_note}\"" || "null"},",
        "\"public_note\":#{"\"#{public_note}\"" || "null"},",
        "\"shift_id\":#{shift_id},",
        "\"physician_id\":#{physician_id}",
      "}",
    "}"
    ].join("")
  end

  private

  def filter_attributes
    self[:duration] = nil if self[:duration] == 0.0
  end
end
