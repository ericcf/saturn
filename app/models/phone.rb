require 'formatters'

class Phone < ActiveRecord::Base

  establish_connection Rails.env == "test" ? :test : :directory

  include Formatters::Phone

end
