class MethodLogger
  def log_method(klass, method_name)
    klass.class_eval do
      alias_method "#{method_name}_original", method_name
      define_method method_name do
        puts "#{Time.now}: Called #{method_name}"
        send "#{method_name}_original"        
      end      
    end
  end
end

class Tweet
  def say_hi
    puts "Hi"
  end
end

logger = MethodLogger.new
logger.log_method(Tweet, :say_hi)

Tweet.new.say_hi()
