class RotationAssignment < ActiveRecord::Base

  belongs_to :person
  belongs_to :rotation

  validates :person, :rotation, :starts_on, :ends_on, :presence => true
  validate :ends_on_not_before_starts_on?

  private

  def ends_on_not_before_starts_on?
    if self[:starts_on] && self[:ends_on]
      unless self[:ends_on] >= self[:starts_on]
        errors.add(:ends_on, "cannot occur before the start")
      end
    end
  end
end