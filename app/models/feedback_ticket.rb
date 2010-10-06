class FeedbackTicket < ActiveRecord::Base

  belongs_to :user, :class_name => "Deadbolt::User"
  belongs_to :status, :class_name => "FeedbackStatus",
    :foreign_key => :status_id

  validates_associated :user, :status
  validates :description, :presence => true

  before_validation :assign_status

  private

  def assign_status
    self[:status_id] = FeedbackStatus.default.id
  end
end
