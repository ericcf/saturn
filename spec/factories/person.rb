require 'factory_girl'

Factory.define :person do |p|
  #factory :person do
    p.given_name "John"
    p.family_name "Appleseed"
  #end
end

Factory.define :physician_membership, :class => Membership do |m|
  m.association :person
  m.association :group, :factory => :faculty_group
end
