class Group < ActiveRecord::Base

  establish_connection Rails.env.to_sym#Rails.env == "test" ? :test : :directory

  has_many :memberships
  has_many :people, :through => :memberships
  
end
