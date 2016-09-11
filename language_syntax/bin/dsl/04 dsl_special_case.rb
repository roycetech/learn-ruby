# Allows optional Text and optional block
class Tweet

  def initialize(user)
    @user = user
    @tweet = []
  end

  def text(str)
    @tweet << str
    self
  end

  def mention(user)
    @tweet << "@#{user}"
    self
  end

  def hashtag(str)
    @tweet << "##{str}"
    self
  end

  def link(str)
    @tweet << str
    self
  end

  def submit_to_twitter
    tweet_text = @tweet.join(' ')
    puts "#{@user}: #{tweet_text}"
  end

end

def tweet_as(user, text = nil, &block)
  tweet = Tweet.new(user)  
  tweet.text(text) if text
  tweet.instance_eval(&block) if block_given?()
  tweet.submit_to_twitter
end


tweet_as 'royce_tech', 'Hello there'
