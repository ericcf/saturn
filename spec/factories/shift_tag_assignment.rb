require 'factory_girl'

Factory.define :shift_tag_assignment do |a|
  a.association :shift
  a.association :shift_tag
end
