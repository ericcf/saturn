require 'factory_girl'

FactoryGirl.define do

  factory :assignment do
    physician_id 1
    shift
    date { Date.today }
  end
end
