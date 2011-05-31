source 'http://rubygems.org'

gem 'rails', '~>3.0.7'
gem 'rake', '~>0.8.7'
gem 'mysql2', '~>0.2.7'
gem 'haml'
gem 'sass'
gem 'will_paginate', '~> 3.0.pre2'
gem 'formtastic'
gem 'http_accept_language'

# custom error pages
gem 'goalie'

gem 'rad_directory', :git => 'git://github.com/ericcf/rad_directory.git'
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
  gem 'launchy'
  gem 'rspec-rails'
  gem 'ruby-debug19', :require => 'ruby-debug'
end

group :development do
  gem 'haml-rails'
  gem 'metric_fu'
  gem 'jquery-rails'
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
  gem 'rad_matchers'
end
