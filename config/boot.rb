# Set up gems listed in the Gemfile.

require 'yaml'
#YAML::ENGINE.yamler= 'syck'

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
