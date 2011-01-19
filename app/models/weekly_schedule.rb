class WeeklySchedule < ActiveRecord::Base

  has_many :assignments, :dependent => :destroy
  accepts_nested_attributes_for :assignments, :allow_destroy => true
  belongs_to :section

  validates_presence_of :section, :date
  validates_uniqueness_of :date, :scope => :section_id

  scope :include_date, lambda { |date|
    where("weekly_schedules.date <= ? and weekly_schedules.date >= ?", date, date - 6)
  }
end
