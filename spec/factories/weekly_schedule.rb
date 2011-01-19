require 'factory_girl'

Factory.define :weekly_schedule do |s|
  s.association :section
  s.date Date.today.beginning_of_week
end

Factory.define :published_weekly_schedule, :parent => :weekly_schedule do |s|
  s.is_published true
end
