class Contact < ActiveRecord::Base

  establish_connection Rails.env.to_sym#Rails.env == "test" ? :test : :directory

end
