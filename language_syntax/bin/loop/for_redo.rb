run_last_twice = false

num = 10

while num > 0
  puts num
  num -= 1
  
  redo if not run_last_twice and num == 0     
end
