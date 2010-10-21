require 'icalendar'

module Saturn

  module Calendars

    class RobustIcalendar

      def initialize(unsanitized_ical_text)
        @sanitized_input = []
        sanitize_input unsanitized_ical_text
        calendars = Icalendar.parse(@sanitized_input.join("\n"))
        @calendar = calendars.first
      end

      def events
        @calendar.events
      end

      private

      def sanitize_input(text)
        if text.respond_to?(:each)
          text.each { |line| sanitize(line) }
        elsif text.respond_to?(:each_line)
          text.each_line { |line| sanitize(line) }
        end
      end

      def sanitize(line)
        encoded_line = line.encode("ASCII", "UTF-8", :invalid => :replace,
                                   :undef => :replace, :replace => "")
        unless encoded_line =~ /^PRODID/
          @sanitized_input << encoded_line
        end
      end
    end
  end
end
