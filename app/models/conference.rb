class Conference < ActiveRecord::Base

  validates :external_uid, :uniqueness => true
  validates :starts_at, :ends_at, :presence => true

  scope :occur_on, lambda { |date|
    where("starts_at >= ? and ends_at < ?", date, date + 1)
  }
end
