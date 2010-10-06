class FeedbackStatus < ActiveRecord::Base

  has_many :tickets, :class_name => "FeedbackTicket",
    :foreign_key => :status_id, :dependent => :nullify

  validates :name, :uniqueness => true, :presence => true

  def self.default
    self.where(:default => true).first ||
      self.first ||
      self.create(:name => "default")
  end
end
