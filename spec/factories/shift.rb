require 'factory_girl'

Factory.define :shift do |s|
  s.title "AM Shift"
  s.association :section, :factory => :section
end
