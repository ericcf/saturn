require 'formatters'

class Phone < ActiveRecord::Base

  establish_connection Rails.env.to_sym#Rails.env == "test" ? :test : :directory

  include Formatters::Phone

end
