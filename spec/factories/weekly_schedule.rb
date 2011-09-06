require 'factory_girl'

FactoryGirl.define do

  factory :weekly_schedule do
    section
    date { Date.today.at_beginning_of_week }
  end
end
