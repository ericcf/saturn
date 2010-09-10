class TabularView

  def initialize(args={ :x => [], :y => [] })
    @x_axis_items = args[:x].first || []
    @x_index_method = args[:x].second
    @y_axis_items = args[:y].first || []
    @y_index_method = args[:y].second
    @mapped_values = args[:mapped_values] || {}
    @content_formatter = args[:content_formatter]
  end

  def each_x_axis_item
    @x_axis_items.each do |obj|
      yield obj
    end
  end

  def each_y_axis_item
    @y_axis_items.each do |obj|
      yield obj
    end
  end

  def value(x_obj, y_obj)
    @mapped_values[[x_obj.send(@x_index_method), y_obj.send(@y_index_method)]]
  end

  def format(obj, join="")
    return if obj.nil?
    if obj.is_a?(Array)
      obj.map { |element| format(element, join) }.join(join)
    else
      @content_formatter.call obj
    end
  end
end
