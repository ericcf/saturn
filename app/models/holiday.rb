class Holiday < ActiveRecord::Base

  validates :date, :title, :presence => true
end
