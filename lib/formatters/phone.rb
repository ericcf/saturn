module Formatters

  module Phone

    def pretty_print(method_name=:value)
      text = send(method_name)
      tail = value.size - 1
      [1, 3, 3, 4].reverse.map do |count|
        if tail < 0
          nil
        else
          tail -= count
          value[[tail+1, 0].max..(tail+count)]
        end
      end.compact.reverse.join("-")
    end
  end
end
