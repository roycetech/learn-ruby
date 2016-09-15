module Module1
  
  def instance
    puts 1
  end

  module ClassMethods

    def static
      puts 2
    end

  end

end


# Test if instance method can be used in a static context.
class Sample
  include Module1
  extend Module1::ClassMethods

  def go1
    instance
  end


end

Sample.new.go1
Sample.static