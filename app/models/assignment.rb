class Assignment < ActiveRecord::Base

  belongs_to :weekly_schedule
  belongs_to :shift
  belongs_to :person

  validates :shift, :person, :date, :presence => true
  validates_numericality_of :position,
    :greater_than_or_equal_to => 1
  validates_uniqueness_of :person_id,
    :scope => [:weekly_schedule_id, :shift_id, :date]

  before_validation :filter_attributes

  scope :by_schedules_and_shifts, lambda { |schedules, shifts|
    where(:weekly_schedule_id => schedules.map(&:id),
          :shift_id => shifts.map(&:id))
  }
  scope :date_in_range, lambda { |start_date, end_date|
    where(["date >= ? and date <= ?", start_date, end_date])
  }

  def public_note_details
    public_note.blank? ? nil : {
      :shift => shift.title,
      :day => date.strftime("%a"),
      :initials => person.initials,
      :text => public_note
    }
  end

  def fixed_duration
    duration || shift.duration
  end

  private

  def filter_attributes
    self[:duration] = nil if self[:duration] == 0.0
  end
end
