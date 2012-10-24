#usage: ruby test.rb biodiversacerif aheugheb <password>

require 'rubygems'
require 'pg'

dbHost = "dev"
dbPort = 5432
dbName=ARGV[0]
dbLogin=ARGV[1]
dbPasswd=ARGV[2]

conn = PGconn.connect(dbHost, dbPort,"","", dbName, dbLogin, dbPasswd)
sql = "select id, origid from cl.sources;"
puts "SQL=#{sql}"
res = conn.exec(sql)
res.each do |s|
  puts  "#{s['id']}-#{s['origid']}"
end
