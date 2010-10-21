require 'spec_helper'

describe MinimalBin do

  it "stores the items in the minimal number of rows" do
    items = [BinItem.new(2, 0), BinItem.new(2, 0)]
    bin = MinimalBin.new(items)
    bin.rows.count.should == 2
    bin.rows.first.should == { :items => [items.first], :size => 2 }
    bin.rows.second.should == { :items => [items.second], :size => 2 }
  end

  it "pads rows which are not filled with items" do
    items = [BinItem.new(2, 1)]
    bin = MinimalBin.new(items, 4)
    bin.rows.count.should == 1
    bin.rows.first[:size].should == 4
    row_items = bin.rows.first[:items]
    row_items.count.should == 3
    row_items.first.should be_instance_of(BinPad)
    row_items.second.should == items.first
    row_items.third.should be_instance_of(BinPad)
  end
end
