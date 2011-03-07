require File.expand_path('../config/application', __FILE__)
require 'rake'
require 'metric_fu'
MetricFu::Configuration.run do |config|
  config.rcov[:test_files] = ['spec/**/*_spec.rb']
  config.rcov[:rcov_opts] << "-Ispec" # Needed to find spec_helper
end

Saturn::Application.load_tasks
