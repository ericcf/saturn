class VacationRequest < ActiveRecord::Base

  belongs_to :requester, :class_name => "Person"
  belongs_to :section

  serialize :dates

  validates :requester, :section, :dates, :presence => true

end
