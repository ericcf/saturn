require 'factory_girl'

Factory.define :user do |u|
  u.email "foo@bar.com"
  u.password "abcdef"
end
