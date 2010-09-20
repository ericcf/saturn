module Tables

  class MulticolumnTabularData < TabularData

    def initialize(args={ :x => [], :y => [] })
      @x_axis_items = args[:x].first || []
      @x_index_method = args[:x].second
      @y_axis_items = args[:y].first || []
      @y_axis_bins = args[:y].second
      @y_index_method = args[:y].third
      @mapped_values = args[:mapped_values] || {}
      @content_formatter = args[:content_formatter]
    end

    def each_y_axis_item_with_bin
      @y_axis_items.each_with_index do |obj, index|
        yield obj, @y_axis_bins[index]
      end
    end
  end
end
