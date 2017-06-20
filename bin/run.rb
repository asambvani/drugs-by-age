require_relative "../config/environment.rb"

db = SQLite3::Database.new('./db/drug_use.db') #cwd is main project folder

sql_runner = SQLRunner.new(db)
sql_runner.create_tables
csv_runner = CSVRunner.new("/csv/drug-use-by-age.csv")
data_hash = csv_runner.to_hash
