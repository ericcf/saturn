require 'factory_girl'

Factory.define :assignment do |a|
  a.association :weekly_schedule
  a.association :shift
  a.association :physician
  a.date Date.today
end
