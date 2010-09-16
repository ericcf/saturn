class Rotation < ActiveRecord::Base

  validates :title, :presence => true

  before_validation { clean_attributes :title, :description }

end
