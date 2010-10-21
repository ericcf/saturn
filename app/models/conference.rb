class Conference < ActiveRecord::Base

  scope :today, lambda {
    where("starts_at >= ? and ends_at < ?", Date.today, Date.tomorrow)
  }
end
