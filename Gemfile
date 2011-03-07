source 'http://rubygems.org'

gem 'rails'
gem 'haml'
gem 'will_paginate', '~> 3.0.pre2'
gem 'formtastic'

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
  gem 'mysql2'
  gem 'mongrel', '= 1.2.0.pre2'
  gem 'haml-rails'
  gem 'launchy'
  gem 'rspec-rails'
  gem 'autotest-standalone'
  gem 'autotest-growl'
  gem 'database_cleaner'
  gem 'selenium-client'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'webrat'
  gem 'capybara'
  gem 'metric_fu'
  gem 'shoulda'
  gem 'jasmine'
  if RUBY_VERSION =~ /1.9/
    gem 'ruby-debug19', :require => 'ruby-debug'
    gem 'simplecov', '>= 0.3.5', :require => false
  end
end
