require 'spec_helper'

describe User do

  let(:mock_physician) { mock_model(Physician) }
  let(:valid_attributes) do
    {
      :email => "foo@bar.com",
      :password => "123456",
      :password_confirmation => "123456"
    }
  end
  let(:user) { User.create!(valid_attributes) }

  subject { user }

  # mass assignments

  it { should allow_mass_assignment_of(:physician_id) }

  # validations

  it "should allow nil for physician_id" do
    User.create(valid_attributes.merge({
      :email => "baz@bar.com",
      :physician_id => nil
    })).should be_valid
  end
end
