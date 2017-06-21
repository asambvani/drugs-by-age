require 'bundler'
Bundler.require
require 'csv'

require_relative "../bin/csv_runner.rb"
require_relative "../bin/sql_runner.rb"
require_relative "../app/models/cohort.rb"
require_relative "../app/models/drug.rb"
require_relative "../app/models/cohorts_drugs.rb"
require_relative "../app/models/query.rb"
