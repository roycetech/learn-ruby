#
#
#def what
#  puts 'What!'
#end
#
#puts(method(:what).call)

class MyClass
  
    def my_method
      puts 'my_method called'
    end
end

obj = MyClass.new.__send__(:my_method)