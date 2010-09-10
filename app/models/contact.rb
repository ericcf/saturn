class Contact < ActiveRecord::Base

  establish_connection Rails.env == "test" ? :test : :directory

end
