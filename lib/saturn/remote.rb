dir = File.expand_path("remote", __FILE__)
$:.unshift dir unless $:.include? dir

require 'saturn/remote/document'
