require 'factory_girl'

Factory.define :section do |s|
  s.sequence(:title) {|n| "General Imaging #{n}"}
end
