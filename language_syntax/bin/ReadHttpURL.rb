#!/usr/bin/env ruby
require 'net/http'
conn = Net::HTTP.get_response('www.example.org', '/')
if conn.message == 'OK'
  
  puts conn.body
  
  # conn.body.scan(/<img src="(.*?)"/) { |image| puts image }

else 
  puts "Did not receive OK"
end
