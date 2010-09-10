require 'spec_helper'

describe "schedules/_group" do

  context "there are no people in the group" do

    it "does not render the group" do
      view.should_receive(:grouped_people).and_return({})
      view.should_receive(:group).any_number_of_times.and_return("Foo")
      render
      rendered.should_not have_selector("div.group")
    end
  end

  context "there are people in the group" do

    it "renders the group" do
      people = [stub_model(Person, :short_name => "F. Bar")]
      view.should_receive(:grouped_people).and_return({ "Bar" => people })
      view.should_receive(:group).any_number_of_times.and_return("Bar")
      render
      rendered.should have_selector("div",
        :class => "group",
        :id => "groups-bar"
      )
    end
  end
end
