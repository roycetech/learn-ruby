class Tweet
  attr_accessor :user, :status
end

tweet = Tweet.new
tweet.instance_eval do
  self.status = "Changing the tweet's status"
end

p tweet.status