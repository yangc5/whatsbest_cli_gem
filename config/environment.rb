require 'sqlite3'

require_relative '../lib/whatsbest.rb'

DB = {:conn => SQLite3::Database.new("db/businesses.db")}
