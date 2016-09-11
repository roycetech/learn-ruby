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

def tweet_as(user, &block)
  tweet = Tweet.new(user)
  # yield tweet
  tweet.instance_eval(&block)
  tweet.submit_to_twitter
end


tweet_as 'royce_tech' do
  mention 'codeschool'
  text('I made a DSL').hashtag('hooray').hashtag('ruby').link('https://codeschool.com')
end
