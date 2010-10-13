require 'spec_helper'

describe "schedules/weekly_call" do

  before(:each) do
    @today, @tomorrow = Date.today, Date.tomorrow
    assign(:start_date, @today)
    assign(:dates, [@today, @tomorrow])
    view.should_receive(:short_date).with(@today).and_return(@today.to_s)
    view.should_receive(:short_date).with(@tomorrow).and_return(@tomorrow.to_s)
    assign(:call_shifts, [])
    assign(:call_assignments, [])
  end

  it "renders @start_date" do
    render
    rendered.should have_selector("h3",
      :content => "Week of #{@today.to_s(:long)}"
    )
  end

  it "renders a table with headers labeled by date from @dates" do
    render
    rendered.should have_selector("table") do |table|
      table.should have_selector("tr") do |tr|
        tr.should have_selector("th", :content => @today.to_s)
        tr.should have_selector("th", :content => @tomorrow.to_s)
      end
    end
  end

  context "with populated call shifts" do

    before(:each) do
      @call_shifts = assign(:call_shifts, [
        mock_model(Shift, :title => "Shift A"),
        mock_model(Shift, :title => "Shift B")
      ])
    end

    it "renders the call shift titles on the rows from @call_shifts" do
      render
      rendered.should have_selector("table") do |table|
        table.should have_selector("tr > th", :content => "Shift A")
        table.should have_selector("tr > th", :content => "Shift B")
      end
    end

    it "renders the assignments corresponding to the shifts and dates" do
      mock_physician = stub('Physician', :short_name => "L. Effant")
      assign(:call_assignments, [
        mock_model(Assignment,
                   :physician => mock_physician,
                   :shift_id => @call_shifts.first.id,
                   :date => @today)
      ])
      render
      rendered.should have_selector("table") do |table|
        table.should have_selector("tr > td",
          :content => mock_physician.short_name
        )
      end
    end
  end
end
