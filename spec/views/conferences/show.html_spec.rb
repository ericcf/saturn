require 'spec_helper'

describe "conferences/show.html.haml" do

  let(:mock_conference) do
    stub_model(Conference,
      :title => "My Title",
      :starts_at => DateTime.now,
      :ends_at => DateTime.now,
      :description => "My Description",
      :external_uid => "My External Uid",
      :categories => "MyText"
    )
  end

  before(:each) do
    assign(:conference, mock_conference)
    render
  end

  subject { rendered }

  it { should contain("My Title") }

  it { should contain("My Description") }

  it { should contain("My External Uid") }

  it { should contain(mock_conference.starts_at.to_s) }

  it { should contain(mock_conference.ends_at.to_s) }
end
