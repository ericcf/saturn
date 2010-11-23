class WeeklySchedule < ActiveRecord::Base

  has_many :assignments, :dependent => :destroy
  accepts_nested_attributes_for :assignments, :allow_destroy => true
  belongs_to :section

  validates_presence_of :section, :date
  validates_uniqueness_of :date, :scope => :section_id

  scope :published, lambda { where(["published_at is not null"]) }

  scope :include_date, lambda { |date|
    where("weekly_schedules.date <= ? and weekly_schedules.date >= ?", date, date - 6)
  }

  def published?
    !published_at.nil?
  end
  alias :publish :published?

  def publish=(value)
    if value.to_i == 1
      self[:published_at] = Time.now
    else
      self[:published_at] = nil
    end
  end
end
