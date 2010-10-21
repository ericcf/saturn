dir = File.expand_path("calendars", __FILE__)
$:.unshift dir unless $:.include? dir

require 'saturn/calendars/robust_icalendar'
