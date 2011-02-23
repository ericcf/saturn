module Tables

  class TabularRow

    attr_reader :header

    def initialize(header, row_data=[])
      @header, @row_data = header, row_data
    end

    def each_value
      @row_data.each do |value|
        yield value
      end
    end

    def cells
      @row_data
    end
  end

  class TabularStore

    attr_reader :row_headers, :col_headers

    def initialize(args={})
      @row_headers, @col_headers = args[:row_headers], args[:col_headers]
      @values_by_index = args[:values]
    end

    def each_row_header
      @row_headers.each do |header|
        yield header
      end
    end

    def each_col_header
      @col_headers.each do |header|
        yield header
      end
    end

    def each_row
      (0..@row_headers.count-1).each do |row_index|
        row_data = []
        (0..@col_headers.count-1).each do |col_index|
          row_data << @values_by_index[[row_index, col_index]]
        end
        yield TabularRow.new(@row_headers[row_index], row_data)
      end
    end
  end
end
