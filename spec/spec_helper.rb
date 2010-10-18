if RUBY_VERSION =~ /1.9/
  require 'simplecov'
  SimpleCov.start 'rails' do
    add_filter "/vendor/"
  end
end

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
require 'deadbolt_spec_support'

RSpec.configure do |config|
  config.mock_with :rspec

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, comment the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.include(PartialHelpers, :type => :view)
end
