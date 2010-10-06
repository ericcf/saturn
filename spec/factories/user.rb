require 'factory_girl'

Factory.define :user do |u|
  #factory :user do
    u.email "foo@bar.com"
    u.password "abcdef"
  #end
end
