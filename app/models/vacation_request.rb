class VacationRequest < ActiveRecord::Base

  belongs_to :requester, :class_name => "Physician"
  belongs_to :section

  serialize :dates

  validates :requester, :section, :dates, :presence => true

end
