require 'factory_girl'

Factory.define :weekly_schedule do |s|
  #factory :weekly_schedule do
    s.association :section
    s.date Date.today
  #end
end
