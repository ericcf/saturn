require 'factory_girl'

Factory.define :section do |s|
  #factory :section do
    s.sequence(:title) {|n| "General Imaging #{n}"}
  #end
end
