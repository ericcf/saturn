class HelpQuestion < ActiveRecord::Base

  validates :title, :presence => true
end
