def mymethod(&identifier)  
  identifier.call
  # statements
end

mymethod do
  # statements 
end

my_lamb = lambda do
  puts "My lamb"  
end

mymethod(&my_lamb)

