# 1. Using an alias
class Twitter
  
  def tweet(msg)
    puts(msg)
  end

  alias_method :say ,:tweet
end

twitter = Twitter.new
twitter.tweet("Hello")
twitter.say("World")
