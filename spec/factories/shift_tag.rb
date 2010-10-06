require 'factory_girl'

Factory.define :shift_tag do |t|
  t.title "Call"
  t.association :section
end
