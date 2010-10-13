# AttributeCleaner

## Installation
    rails plugin install git@github.com:ericcf/attribute_cleaner.git

## Example model usage
    before_validation { clean_text_attributes :foo, :bar }

## Example RSpec matcher usage
    it { should clean_text_attribute(:foo) }

Copyright (c) 2010 [name of plugin creator], released under the MIT license
