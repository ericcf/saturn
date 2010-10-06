require 'factory_girl'

Factory.define :assignment do |a|
  #factory :assignment do
    a.association :weekly_schedule
    a.association :shift
    a.association :person
    a.date Date.today
  #end
end
