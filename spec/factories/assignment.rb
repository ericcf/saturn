require 'factory_girl'

Factory.define :assignment do |a|
  #factory :assignment do
    a.association :weekly_schedule
    a.association :shift
    a.association :physician
    a.date Date.today
  #end
end
