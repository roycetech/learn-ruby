run_five_twice = false

for num in 1..10

  puts num
  
  if num == 5 and not run_five_twice
    run_five_twice = true
    redo    
  end
  
end