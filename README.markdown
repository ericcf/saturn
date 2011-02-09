# Saturn

A Rails 3 application for managing physicians' rotation schedules, specifically targeting academic medical institutions.

## Installation
1. git clone git://github.com/ericcf/saturn.git
2. configure Gemfile; bundle install
3. set up your database.yml file and database(s) as necessary

## Dependencies
Currently, this depends on [deadbolt](http://github.com/ericcf/deadbolt) for authentication/authorization and [rad_directory](http://github.com/ericcf/rad_directory) as the source of physicians. On the client side, it uses jQuery and jQuery UI, in addition to Knockout.

## Testing
Run RSpec specs with:
    rspec /path/to/saturn

Start jasmine server with:
    rake jasmine
Then open up localhost:8888 in a browser.

Run Cucumber features with:
    cucumber

## Features
* Supports multiple sections
* Supports multiple types of users (currently Faculty, Fellows, Residents)
* Provides drag-n-drop shift assignments
* Schedule editing and publishing is built with Ajax and requires no page refreshing
* Exports section reports to Excel
* Exports individual schedules to iCalendar
* Allows for grouping shifts into "categories" (e.g. AM, PM, Clinical)
* Basic manual vacation and meeting request management

## Todo
* Sync with external calendars
* Rule-based automated shift assignment
* Resident rotation scheduling
* E-mail notification

## Copyright
Copyright (c) 2011 Eric Carty-Fickes, released under MIT licence
