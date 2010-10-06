require 'factory_girl'

Factory.define :shift do |s|
  #factory :shift do
    s.title "AM Shift"
    s.association :section
  #end
end
