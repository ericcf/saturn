class Assignment < ActiveRecord::Base

  attr_accessible :shift, :shift_id, :physician, :physician_id, :date,
    :position, :public_note, :private_note, :duration

  belongs_to :shift
  belongs_to :physician

  validates :shift, :physician, :date, :presence => true
  validates_associated :shift, :physician
  validates_numericality_of :position,
    :greater_than_or_equal_to => 1
  validates_uniqueness_of :physician_id,
    :scope => [:shift_id, :date],
    :message => "Duplicate assignments not allowed"

  before_validation :filter_attributes

  scope :date_in_range, lambda { |start_date, end_date|
    where("assignments.date >= ? and assignments.date <= ?", start_date, end_date)
  }

  default_scope order("assignments.position")

  def self.create_for_dates dates, attributes
    dates.each do |date|
      create(attributes.merge({ :date => date }))
    end
  end

  def physician_name
    physician.present? ? physician.short_name : "Na"
  end

  def shift_title
    shift.present? ? shift.title : "Unknown"
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
      "\"date\":\"#{date}\",",
      "\"duration\":#{duration || "null"},",
      "\"id\":#{id},",
      "\"position\":#{position},",
      "\"private_note\":#{private_note.to_json || "null"},",
      "\"public_note\":#{public_note.to_json || "null"},",
      "\"shift_id\":#{shift_id},",
      "\"physician_id\":#{physician_id}",
    "}"
    ].join("")
  end

  private

  def filter_attributes
    self[:duration] = nil if self[:duration] == 0.0
  end
end
