
# 1. Invoke a global method using its name.
def what
  puts 'What!'
end

method(:what).call


# 2. Invoke a an instance method using its name.
class MyClass
  
    def my_method
      puts 'my_method called'
    end
end

obj = MyClass.new.__send__(:my_method)