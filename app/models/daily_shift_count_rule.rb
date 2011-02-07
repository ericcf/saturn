class DailyShiftCountRule < ActiveRecord::Base

  attr_accessible :section, :shift_tag, :shift_tag_id, :maximum

  belongs_to :section
  belongs_to :shift_tag

  validates :shift_tag, :presence => true
  validates :shift_tag_id, :uniqueness => true
  validates_associated :section, :shift_tag
  validates :maximum, :numericality => {
    :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => 99,
    :allow_nil => true
  }

  def process(assignments_by_physician_id)
    group_over_maximum = []
    assignments_by_physician_id.each do |physician_id, assignments|
      counts_by_date = assignments.each_with_object({}) do |assignment, hash|
        if shift_tag.shift_ids.include? assignment.shift_id
          hash[assignment.date] ||= 0
          hash[assignment.date] += 1
        end
      end
      counts_by_date.each do |date, count|
        summary = { :physician_id => physician_id, :description => "#{count} on #{date.strftime("%a #{date.month}/#{date.day}")}" }
        group_over_maximum << summary if count > maximum
      end
    end
    group_over_maximum
  end
end
