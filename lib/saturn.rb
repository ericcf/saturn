libdir = File.expand_path("saturn", __FILE__)
$:.unshift libdir unless $:.include? libdir

require 'saturn/calendars'
require 'saturn/remote'
