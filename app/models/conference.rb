class Conference < ActiveRecord::Base

  attr_accessible :title, :presenter, :description, :external_uid, :starts_at,
    :ends_at, :categories, :location, :contact

  validates :external_uid, :uniqueness => true, :allow_nil => true
  validates :title, :starts_at, :ends_at, :presence => true
  validates_uniqueness_of :title, :scope => [:starts_at, :ends_at]

  scope :occur_on, lambda { |date|
    where("starts_at >= ? and ends_at < ?", date, date + 1)
  }
end
