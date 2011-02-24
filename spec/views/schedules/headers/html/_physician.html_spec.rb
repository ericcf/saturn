require 'spec_helper'

describe "schedules/headers/html/_physician.html" do

  let(:mock_physician) { stub_model(Physician) }

  it do
    render :partial => "schedules/headers/html/physician.html",
      :locals => { :physician => { :title => "Foo", :id => mock_physician.id } }
    rendered.should have_selector("a",
      :href => schedule_physician_path(mock_physician.id),
      :content => "Foo"
    )
  end
end
