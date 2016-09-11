catch :start do
  puts("First")
  throw :start
  puts("Second")
end
