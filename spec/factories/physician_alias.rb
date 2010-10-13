require 'factory_girl'

Factory.define :physician_alias do |a|
  a.association :physician
end
