class BinItem
  attr_reader :size, :position, :data

  def initialize(size, position, data=nil)
    @size, @position, @data = size, position, data
  end

  #def to_s
  #  (1..@size).map{@size.to_s}.join
  #end
end

class BinPad < BinItem

  #def to_s
  #  (1..size).map{"."}.join
  #end
end

class MinimalBin
  attr_reader :rows

  def initialize(items, size=0)
    @items = items
    @rows = []
    @size = size
    pack
    pad_rows
  end

  #def to_s
  #  puts (1..@size).map{"="}.join
  #  @rows.each do |row|
  #    puts row[:items].map { |item| item.to_s }.join
  #  end
  #  puts (1..@size).map{"="}.join
  #end

  private

  def pack
    items_by_position.keys.sort.each do |position|
      row_index = 0
      items_by_position[position].each do |item|
        row_index = 0
        while init_row(row_index) && @rows[row_index][:size] > item.position
          row_index += 1
        end
        if (pad = item.position - @rows[row_index][:size]) > 0
          @rows[row_index][:items] << BinPad.new(pad, @rows[row_index][:size])
          @rows[row_index][:size] += pad
        end
        @rows[row_index][:items] << item
        @rows[row_index][:size] += item.size
        @size = [@size, @rows[row_index][:size]].max
      end
    end
  end

  def pad_rows
    @rows.each do |row|
      if (pad = @size - row[:size]) > 0
        row[:items] << BinPad.new(pad, row[:size])
        row[:size] += pad
      end
    end
  end

  def init_row(index)
    @rows[index] ||= { :size => 0, :items => [] }
  end

  def items_by_position
    by_position = {}
    @items.each do |item|
      position = item.position
      by_position[position] ||= []
      by_position[position] << item
      by_position[position] = by_position[position].sort do |a, b|
        b.size <=> a.size
      end
    end
    by_position
  end
end
