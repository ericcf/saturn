require 'formatters'

class Phone < DirectoryModel

  #establish_connection Rails.env.to_sym#Rails.env == "test" ? :test : :directory

  include Formatters::Phone

end
