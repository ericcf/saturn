source 'http://rubygems.org'

gem 'rails'
gem 'haml'
gem 'will_paginate', '~> 3.0.pre2'
gem 'formtastic'
gem 'http_accept_language'

# custom error pages
gem 'goalie'

#gem 'rad_directory', :git => 'git://github.com/ericcf/rad_directory.git'
gem 'rad_directory', :path => "/Users/ericcf/projects/rad_directory"
# required by Rad Directory
gem 'rack-cache', :require => 'rack/cache'
gem 'dragonfly'
gem 'friendly_id'
# authentication/authorization
gem 'deadbolt', :git => 'git://github.com/ericcf/deadbolt.git'
gem 'devise'
gem 'cancan'

# Gmail interaction
gem 'tlsmail'

# Excel export
gem 'ekuseru'

# Excel import (roo and dependencies)
#gem 'roo'
#gem 'zip'
#gem 'google-spreadsheet-ruby'

# iCalendar import/export
gem 'vpim'
gem 'icalendar'

# Deployment
gem 'capistrano'
gem 'exception_notification', :git => 'git://github.com/rails/exception_notification', :require => 'exception_notifier'

group :development, :test do
  gem 'mysql2'
  gem 'launchy'
  gem 'rspec-rails'
  if RUBY_VERSION =~ /1.9/
    gem 'ruby-debug19', :require => 'ruby-debug'
  end
end

group :development do
  gem 'haml-rails'
  gem 'metric_fu'
end

group :test do
  gem 'simplecov'
  gem 'autotest-standalone'
  gem 'autotest-growl'
  gem 'database_cleaner'
  gem 'selenium-client'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'webrat'
  gem 'capybara'
  gem 'shoulda'
  gem 'jasmine'
end
