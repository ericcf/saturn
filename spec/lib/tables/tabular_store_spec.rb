require 'spec_helper'

describe Tables::TabularStore do

  before(:each) do
    @store = Tables::TabularStore.new({
      :row_headers => ["Row 1"],
      :col_headers => ["Col 1"],
      :values => { [0, 0] => "Value 1A" }
    })
  end

  describe "#each_row_header" do

    it "yields row headers" do
      yielded = []
      @store.each_row_header do |header|
        yielded << header
      end
      yielded.should eq(["Row 1"])
    end
  end

  describe "#each_col_header" do

    it "yields column headers" do
      yielded = []
      @store.each_col_header do |header|
        yielded << header
      end
      yielded.should eq(["Col 1"])
    end
  end

  describe "#rows" do

    it "returns TabularRow objects" do
      rows = @store.rows
      rows.size.should == 1
      row = rows.first
      row.should be_a(Tables::TabularRow)
      yielded_values = []
      row.each_value do |value|
        yielded_values << value
      end
      yielded_values.should eq(["Value 1A"])
    end
  end
end
