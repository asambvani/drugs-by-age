require_relative "../config/environment.rb"

db = SQLite3::Database.new('../db/drug_use.db')
sql_runner = SQLRunner.new(db)

sql_runner.create_tables
