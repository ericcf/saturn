# only uncomment if you want a coverage report - it slows down the specs!
#if RUBY_VERSION =~ /1.9/
#  require 'simplecov'
#  SimpleCov.start 'rails' do
#    add_filter "/vendor/"
#  end
#end

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
require 'deadbolt_spec_support'

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true

  config.include(PartialHelpers, :type => :view)
end
