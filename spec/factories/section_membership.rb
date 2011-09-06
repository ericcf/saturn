require 'factory_girl'

FactoryGirl.define do

  factory :section_membership do
    physician_id 1
    section
  end
end
