require 'spec_helper'

describe "conferences/show" do
  before(:each) do
    @conference = assign(:conference, stub_model(Conference,
      :title => "My Title",
      :starts_at => DateTime.now,
      :ends_at => DateTime.now,
      :description => "My Description",
      :external_uid => "My External Uid",
      :categories => "MyText"
    ))
    render
  end

  subject { rendered }

  it { should contain("My Title") }

  it { should contain("My Description") }

  it { should contain("My External Uid") }

  it { should contain(@conference.starts_at.to_s) }

  it { should contain(@conference.ends_at.to_s) }
end
