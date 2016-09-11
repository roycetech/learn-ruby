puts("begin")

begin
  1/0;
rescue
  puts 'rescue'
ensure
  puts 'ensure'
end

puts 'end'