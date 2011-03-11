require 'spec_helper'

describe User do

  let(:mock_physician) { mock_model(Physician, :valid? => true) }
  let(:valid_attributes) do
    {
      :email => "foo@bar.com",
      :password => "123456",
      :password_confirmation => "123456"
    }
  end
  let(:user) { User.create!(valid_attributes) }

  before(:each) do
    Physician.stub!(:find).with(mock_physician.id, anything) { mock_physician }
  end

  subject { user }

  # database

  it { should have_db_index(:physician_id).unique(true) }

  # mass assignments

  it { should allow_mass_assignment_of(:physician_id) }

  # associations

  it { should belong_to(:physician) }

  # validations

  it { should validate_associated(:physician) }

  it "should validate uniqueness of physician_id" do
    user_attributes = valid_attributes.merge({
      :email => "foo2@bar.com",
      :physician_id => mock_physician.id
    })
    User.create(user_attributes).should be_valid
    User.create(user_attributes).should have(1).error_on(:physician_id)
  end

  it "should allow nil for physician_id" do
    User.create(valid_attributes.merge({
      :email => "baz@bar.com",
      :physician_id => nil
    })).should be_valid
  end
end
