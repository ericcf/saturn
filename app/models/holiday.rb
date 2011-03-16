class Holiday < ActiveRecord::Base

  attr_accessible :date, :title

  validates :date, :title, :presence => true
end
