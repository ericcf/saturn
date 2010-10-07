class Membership < ActiveRecord::Base

  establish_connection Rails.env.to_sym#Rails.env == "test" ? :test : :directory

  belongs_to :person, :foreign_key => :contact_id
  belongs_to :group
end
