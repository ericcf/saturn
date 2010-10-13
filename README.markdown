# Scheduler

A Rails 3 application for managing physicians' rotation schedules.

## Installation
1. set up your database.yml file and database(s) as necessary

## Testing
Run specs with:
    rake spec

Start jasmine server with:
    rake jasmine
Then open up localhost:8888 in a browser.

## Features
* Supports multiple sections
* Supports multiple types of users (currently Faculty, Fellows, Residents)
* Provides drag-n-drop shift assignments
* Exports section reports to Excel
* Exports individual schedules to iCalendar
* Allows for grouping shifts into "categories" (e.g. AM, PM, Clinical)

## Todo
* Sync with external calendars
* Rule-based automated shift assignment
* Vacation request management
* Meeting request management
* Resident rotation scheduling
* E-mail notification

## Copyright
Copyright (c) 2010 Eric Carty-Fickes, released under MIT licence
