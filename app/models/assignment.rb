class Assignment < ActiveRecord::Base

  belongs_to :weekly_schedule
  belongs_to :shift
  belongs_to :physician

  validates :shift, :physician, :date, :presence => true
  validates_numericality_of :position,
    :greater_than_or_equal_to => 1
  validates_uniqueness_of :physician_id,
    :scope => [:weekly_schedule_id, :shift_id, :date]

  before_validation :filter_attributes

  scope :by_schedules_and_shifts, lambda { |schedules, shifts|
    where(:weekly_schedule_id => schedules.map(&:id),
          :shift_id => shifts.map(&:id))
  }
  scope :date_in_range, lambda { |start_date, end_date|
    where("assignments.date >= ? and assignments.date <= ?", start_date, end_date)
  }
  scope :published, lambda {
    joins(:weekly_schedule).where("weekly_schedules.published_at is not null")
  }
  default_scope order(:position)

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

  private

  def filter_attributes
    self[:duration] = nil if self[:duration] == 0.0
  end
end
