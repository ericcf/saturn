class Rotation < ActiveRecord::Base

  attr_accessible :title, :description

  validates :title, :presence => true

  before_validation { clean_text_attributes :title, :description }

end
