
def method1
  puts caller.join(', ')
end

def method2
  puts caller.join(', ')
  method1()
end

method1()
method2()